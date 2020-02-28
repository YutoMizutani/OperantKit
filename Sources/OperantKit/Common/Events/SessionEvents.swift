//
//  SessionEvents.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/08/27.
//

import RxCocoa
import RxSwift

public class SessionEvents {
    public var eventIDs: [String]
    public typealias EventMarker = (id: Int, milliseconds: Int)
    public private(set) var events: [EventMarker] = []
    public private(set) var willWrite: PublishRelay<Int> = PublishRelay()

    public init(eventIDs: [String]) {
        self.eventIDs = eventIDs
    }

    /// 00: Event name
    public var EVENTS: String {
        return "EVENTS\n"+self.eventIDs.map { "\(self.translateFormatID(self.eventIDs.index(of: $0)!+1)): \($0)" }.joined(separator: "\n")
    }

    /// 00: 1000(milliseconds)
    public var listOfEvents: String {
        return listOfEvents(from: self.events)
    }
    /// 人間確認用
    public var logWithText: String {
        let maxTextLength = eventIDs.map { Int($0.count) }.max()
        var result = ""
        for e in self.events {
            let id = e.id - 1
            let eventName = eventIDs[id]
            let spaces = String(repeating: " ", count: maxTextLength != nil ? maxTextLength!-Int(eventName.count) : 0)
            result += "\(eventName): \(spaces)\(e.milliseconds)\n"
        }
        return result
    }
    /// BLE確認用
    public var logWithID: String {
        return self.events.map { "\(self.translateFormatID($0.id)): \($0.milliseconds)" }.joined(separator: "\n")
    }
    public private(set) var observableEventLog: Variable<(withID: String, withText: String)?> = Variable(nil)

    public func write(id: Int, milliseconds: Int) {
        self.willWrite.accept(id)

        let eventMarker = (id: id, milliseconds: milliseconds)
        self.events.append(eventMarker)
        // observe
        self.observableEventLog.value = (withID: logWithID, withText: logWithText)
    }
}

public extension SessionEvents {
    private func translateEventMarkerToString(_ marker: EventMarker) -> String {
        return "\(self.translateFormatID(marker.id)): \(marker.milliseconds)"
    }

    private func translateFormatID(_ id: Int) -> String {
        // 最大桁数を取得。1桁の場合は2桁にする。
        let maxDigit: Int = "\(self.eventIDs.count)".count == 1 ? 2 : "\(self.eventIDs.count)".count
        // 現在idの桁数を取得
        let digit: Int = "\(id)".count

        let zero: String = String(repeating: "0", count: (maxDigit - digit))

        return "\(zero)\(id)"
    }

    /// idを元に抽出したtimeデータのみ取り出す。
    public func events(by id: Int) -> [Int] {
        return self.events.filter { $0.id == id }.map { $0.milliseconds }
    }
    public func getId(from text: String) -> Int? {
        for i in 0..<self.eventIDs.count where text == self.eventIDs[i] {
            return i + 1
        }
        return nil
    }
    /// 最後のafter idから数えていくつtarget idがあるか取得する。
    public func events(by targetID: Int, after afterID: Int?) -> [Int] {
        var afterEvents = self.events
        if afterID == nil {
            return afterEvents.filter { $0.id == targetID }.map { $0.milliseconds }
        }
        // 最後のafterIDのEMを取得。
        let lastEM = self.events.filter { $0.id == afterID }.last
        if !self.events.isEmpty && lastEM != nil {
            for i in 0..<self.events.count where self.events[i] == lastEM! {
                afterEvents = Array(self.events.dropFirst(i))
                break
            }
        }
        return afterEvents.filter { $0.id == targetID }.map { $0.milliseconds }
    }

    /// 最後のbefore idまでに数えていくつtarget idがあったか。（強化後の反応数を取得するために使用。）
    public func events(by targetID: Int, before beforeID: Int?) -> [Int] {
        var afterEvents = self.events
        // 最後のafterIDのEMを取得。
        let lastEM = self.events.filter { $0.id == beforeID }.last
        if beforeID == nil || lastEM == nil {
            return []
        }

        if !self.events.isEmpty && lastEM != nil {
            for i in 0..<self.events.count where self.events[i] == lastEM! {
                afterEvents = Array(self.events.prefix(i))
                break
            }
        }
        return afterEvents.filter { $0.id == targetID }.map { $0.milliseconds }
    }

    public func listOfEvents(from events: [EventMarker]) -> String {
        var results: String = ""
        for e in events {
            results += translateEventMarkerToString(e) + "\n"
        }

        return results
    }

    public func elapsedEvents(events: [EventMarker], skipID: (before: Int, after: Int)) -> (extendTime: Int, events: [EventMarker]) {
        var events = events
        var extendTime = 0

        let beforeCount = events.filter { $0.id == skipID.before }.count
        for i in (0..<beforeCount).reversed() {
            let beforeTime = events.filter { $0.id == skipID.before }[i].milliseconds
            let afterEvents = events.filter { $0.id == skipID.after }
            let afterTime = i < afterEvents.count ? afterEvents[i].milliseconds : (events.last?.milliseconds) ?? 0

            events = events
                // before - after 間のイベントを削除
                .filter { $0.milliseconds <= beforeTime || $0.milliseconds >= afterTime }
                // after 以後のイベントを (afterTime - beforeTime) だけ消す。
                .map {
                    if $0.milliseconds >= afterTime {
                        return (id: $0.id, milliseconds: $0.milliseconds - (afterTime - beforeTime))
                    } else {
                        return $0
                    }
                }
            extendTime += (afterTime - beforeTime)
        }
        return  (extendTime: extendTime, events: events)
    }
    /// 経過時間を測定する。id間のイベントをフィルタリングし，有効時間を算出する。(realTime->SessionTimeやFIのICIを算出)
    public func elapsedTime(startTime: Int = 0, endTime: Int? = nil, skipIDs: [(before: Int, after: Int)]) -> Int {
        var events = self.events.filter { $0.milliseconds > startTime }
        var endTime = events.last.map { $0.milliseconds } ?? 0

        // 経過時間を調べるため，フィルタリングの前にendTimeを無効ID: -1 に追加
        let invalidID: Int = -1
        events.append((id: invalidID, milliseconds: endTime))

        // フィルタリングを行う。
        skipIDs.forEach {
            events = self.elapsedEvents(events: events, skipID: $0).events
        }

        // 経過時間を算出
        endTime = events.last.map { $0.milliseconds } ?? 0
        return endTime - startTime
    }
    /// フィルタリングしない経過時間を返す。
    public func extendTime(startTime: Int = 0, endTime: Int?=nil, skipIDs: [(before: Int, after: Int)]) -> Int {
        var events = self.events.filter { $0.milliseconds > startTime }

        var extendTime = 0
        skipIDs.forEach {
            let elapsedEvents = self.elapsedEvents(events: events, skipID: $0)
            events = elapsedEvents.events
            extendTime += elapsedEvents.extendTime
        }

        // 経過時間を算出
        return extendTime
    }
}
