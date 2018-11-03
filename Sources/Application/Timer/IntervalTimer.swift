//
//  IntervalTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/08/25.
//

import Foundation

/// Main Timer for experiments
public class IntervalTimer {

    // MARK: - Typealias

    public typealias TimerEvent = (closure: (() -> Void), milliseconds: Int)

    // MARK: - Privates

    private let lock = NSLock()
    private let asyncQueue = DispatchQueue(label: "IntervalTimerAsyncQueue", qos: .default, attributes: .concurrent)
    private let syncQueue = DispatchQueue(label: "IntervalTimerSyncQueue", qos: .userInitiated, attributes: .concurrent)

    /// Interval time milliseconds per cycle
    private var intervalMilliseconds: Double
    /// Start time when sleep
    private var sleepStartMilliseconds: Int?

    // MARK: - States

    /// The working state of this timer(looper).
    public private(set) var isCompleted: Bool = false
    /// The state of the session is in the loop.
    public private(set) var isRunning: Bool = false
    /// The stop looping during the session.
    public private(set) var isSleeping: Bool = false
    /// Elapsed time
    public private(set) var milliseconds: Int = 0

    // MARK: - Events

    /// If the timer milliseconds, called closure
    public private(set) var eventClosure: [TimerEvent] = []

    // MARK: - DEBUG

    #if DEBUG
    /// [DEBUG] Use debug mode
    private var isDebug: Bool = false
    /// [DEBUG] Previous stored seconds
    private var debugPreviousSeconds: Int = 0
    /// [DEBUG] Debug text
    public private(set) var debugText: String?
    /// [DEBUG] Loop count
    public private(set) var debugLoopValue: (callCount: Int, waitCount: Int) = (1, 0)
    #endif

    // MARK: - init

    /// - Parameter intervalMilliseconds: ループ頻度。intervalMillisecondsミリ秒経過するまでは待機ループで待機。
    public init(_ intervalMilliseconds: Double = 0.1) {
        self.intervalMilliseconds = intervalMilliseconds
        self.resetValue()
    }

    #if DEBUG
    /// - Parameters:
    ///    - intervalMilliseconds: ループ頻度。intervalMillisecondsミリ秒経過するまでは待機ループで待機。
    ///    - isDebug: Use debug mode
    public convenience init(_ intervalMilliseconds: Double = 0.1, isDebug: Bool) {
        self.init(intervalMilliseconds)
        self.isDebug = isDebug
    }
    #endif
}

// MARK: - Private functions
private extension IntervalTimer {
    func resetValue() {
        self.isCompleted = false
        self.isRunning = true
        self.isSleeping = true
        self.milliseconds = 0
        #if DEBUG
        self.debugText = nil
        self.debugLoopValue = (1, 0)
        self.debugPreviousSeconds = 0
        #endif
    }

    /// Start timer
    func fire(_ startDate: Date) {
        self.isSleeping = false
        self.isCompleted = false
        var date: (start: Date, previous: Date) = (startDate, startDate)

        func runLoop() {
            // isRunning中は
            while self.isRunning {
                while self.isRunning && !self.isSleeping {
                    // Wait within the loop until the 'intervalMilliseconds' passed.
                    waitLoop: do {
                        #if DEBUG
                        // Reset loop count
                        self.debugLoopValue.waitCount = 0
                        #endif
                        // 開始Dateから経過ミリ秒を加えた経過時間Dateを発行
                        date.previous = Date(timeInterval: Double(self.milliseconds) / 1000, since: date.start)
                        // 経過Dateから現在までの経過時刻を算出し，インターバル値を上回るまで待機ループ。
                        var tmpDate: Date = Date()
                        while tmpDate.timeIntervalSince(date.previous) <= (self.intervalMilliseconds) / 1000 {
                            #if DEBUG
                            self.debugLoopValue.waitCount += 1
                            #endif
                            tmpDate = Date()
                        }
                        // 待機ループ脱出後，経過ミリ秒を更新
                        self.milliseconds = Int(tmpDate.timeIntervalSince(date.start) * 1000)
                    }

                    // Do eventFlag from eventAlerm
                    doFlag: do {
                        if !self.isSleeping {
                            // スリープ時間が格納されていれば，その時間だけ通知を遅らせる。
                            if self.sleepStartMilliseconds != nil {
                                let sleepTime = self.milliseconds - self.sleepStartMilliseconds! + 2
                                self.eventClosure = self.eventClosure.map {
                                    ($0.closure, milliseconds: $0.milliseconds + sleepTime)
                                }

                                self.sleepStartMilliseconds = nil
                            }
                            executeEvent()
                            removeEvent()

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
                while self.isRunning && self.isSleeping {
                    // Sleeping until wake up
                }
            }
            self.isCompleted = true
        }

        // メインでループを回すと他の描画処理ができなくなるため，グローバルスレッドを利用
        self.asyncQueue.async { [unowned self] in
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
        let seconds: Int = Int(self.milliseconds / 1000)
        if seconds != self.debugPreviousSeconds {
            self.debugPreviousSeconds = seconds
            print("""
                [\(#function)]
                Milliseconds : \(self.milliseconds)
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
        self.resetValue()
        let startDate = Date()
        self.fire(startDate)
    }

    /// Go sleep timer
    func sleep() {
        self.isSleeping = true
        self.sleepStartMilliseconds = self.milliseconds
    }

    /// Wake up timer
    func wakeUp() {
        self.isSleeping = false
    }

    /// Finish timer
    func finish() {
        self.isRunning = false
    }

    /// Set timer event
    func addEvent(_ closure: @escaping (() -> Void), _ milliseconds: Int) {
        lock.lock()
        defer { lock.unlock() }
        self.eventClosure.append((closure, milliseconds))
    }
}

extension IntervalTimer {
    private func executeEvent() {
        lock.lock()
        defer { lock.unlock() }
        // eventClosureの数だけ回し，eventClosureの時間が一致した場合，
        for event in self.eventClosure where event.milliseconds <= self.milliseconds {
            // eventを発火させる
            event.closure()
        }
    }

    private func removeEvent() {
        lock.lock()
        defer { lock.unlock() }
        self.eventClosure = self.eventClosure.filter { [unowned self] in $0.milliseconds > self.milliseconds }
    }
}
