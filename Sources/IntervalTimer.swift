//
//  IntervalTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/08/25.
//

import RxCocoa
import RxSwift

/// Main Timer for experiments
public class IntervalTimer {

    // MARK: - Privates

    private let asyncQueue = DispatchQueue(label: "IntervalTimerAsyncQueue", qos: .default, attributes: .concurrent)
    private let syncQueue = DispatchQueue(label: "IntervalTimerSyncQueue", qos: .userInitiated, attributes: .concurrent)

    /// Interval time milliseconds per cycle
    private var intervalMilliseconds: Double
    /// Start time when sleep
    private var sleepStartMilliseconds: Int?

    // MARK: - States

    /// The working state of this timer(looper).
    public private(set) var isCompleted: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// The state of the session is in the loop.
    public private(set) var isRunning: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// The stop looping during the session.
    public private(set) var isSleeping: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    /// Elapsed time
    public private(set) var elapsed: (date: Date, milliseconds: BehaviorRelay<Int>) = (Date(), BehaviorRelay(value: 0))

    // MARK: - Events

    /// If the timer milliseconds, call 'isEventFlag' with id.
    public private(set) var eventAlerm: [(id: Int, milliseconds: Int)] = []
    /// It is change with eventAlerm-id.
    public private(set) var eventFlag: BehaviorRelay<(id: Int, milliseconds: Int)?> = BehaviorRelay(value: nil)

    // MARK: - DEBUG

    #if DEBUG
    /// [DEBUG] Use debug mode
    private var isDebug: Bool = false
    /// [DEBUG] Previous stored seconds
    private var debugPreviousSeconds: Int = 0
    /// [DEBUG] Debug text
    public private(set) var debugText: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    /// [DEBUG] Loop count
    public private(set) var debugLoopValue: (callCount: Int, waitCount: Int) = (1, 0)
    #endif

    // MARK: - init

    /// - Parameter intervalMilliseconds: ループ頻度。intervalMillisecondsミリ秒経過するまでは待機ループで待機。
    init(_ intervalMilliseconds: Double = 0.1) {
        self.intervalMilliseconds = intervalMilliseconds
        _ = self.resetValue()
    }

    #if DEBUG
    /// - Parameters:
    ///    - intervalMilliseconds: ループ頻度。intervalMillisecondsミリ秒経過するまでは待機ループで待機。
    ///    - isDebug: Use debug mode
    convenience init(_ intervalMilliseconds: Double = 0.1, isDebug: Bool) {
        self.init(intervalMilliseconds)
        self.isDebug = isDebug
    }
    #endif
}

// MARK: - Private functions
private extension IntervalTimer {
    func resetValue() -> Date {
        self.isCompleted.accept(false)
        self.isRunning.accept(true)
        self.isSleeping.accept(true)
        let date = Date()
        self.elapsed.date = date
        self.elapsed.milliseconds.accept(0)
        #if DEBUG
        self.debugText.accept(nil)
        self.debugLoopValue = (1, 0)
        self.debugPreviousSeconds = 0
        #endif
        return date
    }

    /// Start timer
    func fire(_ startDate: Date) {
        self.isSleeping.accept(false)
        self.isCompleted.accept(false)
        var date: (start: Date, previous: Date) = (startDate, startDate)

        func runLoop() {
            // isRunning中は
            while self.isRunning.value {
                while self.isRunning.value && !self.isSleeping.value {
                    // Wait within the loop until the 'intervalMilliseconds' passed.
                    waitLoop: do {
                        #if DEBUG
                        // Reset loop count
                        self.debugLoopValue.waitCount = 0
                        #endif
                        // 開始Dateから経過ミリ秒を加えた経過時間Dateを発行
                        date.previous = Date(timeInterval: Double(self.elapsed.milliseconds.value) / 1000, since: date.start)
                        // 経過Dateから現在までの経過時刻を算出し，インターバル値を上回るまで待機ループ。
                        var tmpDate: Date = Date()
                        while tmpDate.timeIntervalSince(date.previous) <= (self.intervalMilliseconds) / 1000 {
                            #if DEBUG
                            self.debugLoopValue.waitCount += 1
                            #endif
                            tmpDate = Date()
                        }
                        // 待機ループ脱出後，経過ミリ秒を更新
                        self.elapsed.milliseconds.accept(Int(tmpDate.timeIntervalSince(date.start) * 1000))
                        self.elapsed.date = tmpDate
                    }

                    // Do eventFlag from eventAlerm
                    doFlag: do {
                        if !self.isSleeping.value {
                            // スリープ時間が格納されていれば，その時間だけ通知を遅らせる。
                            if self.sleepStartMilliseconds != nil {
                                let sleepTime = self.elapsed.milliseconds.value - self.sleepStartMilliseconds! + 2
                                self.eventAlerm = self.eventAlerm.map {
                                    (id: $0.id, milliseconds: $0.milliseconds + sleepTime)
                                }

                                self.sleepStartMilliseconds = nil
                            }

                            // eventAlermの数だけ回し，evantAlermの時間が一致した場合，
                            for event in self.eventAlerm where event.milliseconds <= self.elapsed.milliseconds.value {
                                // event idを，通知可能なeventFlag変数に入れる。
                                self.eventFlag.accept(event)
                                // イベントは破棄される。
                                self.eventAlerm = self.eventAlerm.filter { $0 != event }
                            }

                        }
                    }
                    #if DEBUG
                    countup: do {
                        self.debugLoopValue.callCount += 1
                    }
                    debugPrint: do {
                        if self.isDebug {
                            self.debugPrint(startDate)
                        }
                    }
                    #endif
                }
                while self.isRunning.value && self.isSleeping.value {
                    // Sleeping until wake up
                }
            }
            self.isCompleted.accept(true)
        }

        // メインでループを回すと他の描画処理ができなくなるため，グローバルスレッドを利用
        self.asyncQueue.async {
            // グローバルスレッドでループを回すと完了を待たない。1つのループを回すため，グローバルスレッド内で同期処理を行う。
            self.syncQueue.sync {
                runLoop()
            }
        }
    }
}

// MARK: - DEBUG
#if DEBUG
private extension IntervalTimer {
    // XXX: Sleep復帰時に変更干渉が生じる。このままでは使用不可。
    func debugPrint(_ startDate: Date) {
        let seconds: Int = Int(self.elapsed.milliseconds.value / 1000)
        if seconds != self.debugPreviousSeconds {
            self.debugPreviousSeconds = seconds
            self.debugText.accept("""
                [\(#function)]
                Milliseconds : \(self.elapsed.milliseconds.value)
                Details(ms)  : \(Date().timeIntervalSince(startDate) * 1000)
                Num of loops : \(self.debugLoopValue)
                Interval     : \(self.intervalMilliseconds)-ms
                FPS          : \(Int(1000 / self.intervalMilliseconds)) loops per second
            """)
            self.debugLoopValue.callCount = 1
        }
    }
}
#endif

// MARK: - Disclosable methods
public extension IntervalTimer {
    /// Start timer
    func start() {
        let startDate = self.resetValue()
        self.fire(startDate)
    }

    /// Go sleep timer
    func sleep() {
        self.isSleeping.accept(true)
        self.sleepStartMilliseconds = self.elapsed.milliseconds.value
    }

    /// Wake up timer
    func wakeUp() {
        self.isSleeping.accept(false)
    }

    /// Finish timer
    func finish() {
        self.isRunning.accept(false)
    }

    /// Set timer event
    func addAlerm(_ event: (id: Int, milliseconds: Int)) {
        self.eventAlerm.append(event)
    }

    /// Remove timer event
    func removeAlerm(_ event: (id: Int, milliseconds: Int)) {
        self.eventAlerm = self.eventAlerm.filter { $0 != event }
    }

    /// Remove timer event
    func removeAlerm(_ id: Int) {
        self.eventAlerm = self.eventAlerm.filter { $0.id != id }
    }
}
