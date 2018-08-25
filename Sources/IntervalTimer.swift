//
//  IntervalTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/08/25.
//

import RxCocoa
import RxSwift

public class IntervalTimer {
    // ---------------- Settable ------------------------
    ///
    public private(set) var intervalMilliseconds: Double
    // [isDelayFlag] 処理の遅延が発生しているかを監視する。
    //  isDelayFlag(bool: ループ一周後にインターバル時間を待っていたか(wait loop)に突入したか否か; default: false
    /// - Parameters:
    //    - count: wait loopに突入しなかった(前回のループ処理がインターバル期間内に終了しなかった)連続回数; default: 0
    //    - max: (1,2回の処理遅れは通常起こりうると仮定して)遅延回数の許容範囲; maxToleranceOfDelayContinuousCount; default: 10
    public private(set) var isDelayFlag: (count: Int, max: Int)
    // ---------------- Variables -----------------------
    /// Warning!: Variableを参照するとclass内で変更してもその変更が通知されない場合がある。BehaviorRelay<Bool>で一方通行にする。でも変数が増える。。。
    /// - Parameters:
    ///   - isCompleted: It is WORKING state of this timer(looper).
    ///   - isRunning: It is the state of the session is in the loop.
    ///   - isSleeping: It is the stop looping during the session.
    public private(set) var isCompletedRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isCompleted: Bool = false {
        didSet { self.isCompletedRelay.accept(self.isCompleted) }
    }
    public private(set) var isRunningRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isRunning: Bool = false {
        didSet { self.isRunningRelay.accept(self.isRunning) }
    }
    public private(set) var isSleepingRelay: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    private var isSleeping: Bool = false {
        didSet { self.isSleepingRelay.accept(self.isSleeping) }
    }
    private var sleepStartMilliseconds: Int?

    public private(set) var date:(start:Date, prev:Date) = (Date(), Date())
    public private(set) var elapsed: (date:Date, milliseconds:(previous:Int, now:Variable<Int>)) = (Date(), (0, Variable(0)))
    public private(set) var debugText: Variable<String> = Variable("")
    public private(set) var debugLoopValue: (callCount:Int, waitCount:Int) = (1, 0)
    public private(set) var isRenewal: (user:Int, debug:Int) = (0, 0)

    public func resetValue() {
        self.isCompleted = false
        self.isRunning = true
        self.isSleeping = true
        let date = Date()
        self.date = (date, date)
        self.elapsed = (date, (0, Variable(0)))
        self.debugText = Variable("")
        self.debugLoopValue = (1, 0)
        self.isRenewal = (0, 0)
    }

    /// - Parameters:
    ///   - eventAlerm: if the timer milliseconds, call 'isEventFlag' with id.
    ///   - isEventFlag: It is change with eventAlerm-id.
    public private(set) var eventAlerm: [(id: Int, milliseconds: Int)] = []
    public private(set) var eventFlag: Variable<(id: Int, milliseconds: Int)?> = Variable(nil)

    // ---------------- Initializing -----------------------

    // intervalMilliseconds: ループ頻度。intervalMillisecondsミリ秒経過するまでは待機ループで待機。
    // isDelayCountMax: 0だと変更しない
    init(_ intervalMilliseconds:Double = 0.1, isDelayCountMax:Int = 10) {
        self.intervalMilliseconds = intervalMilliseconds
        self.isDelayFlag = (0, isDelayCountMax)
        self.resetValue()
    }

    // ---------------- Functions -----------------------
    public func fire() {
        self.isSleeping = false
        self.isCompleted = false
        let asyncQueue = DispatchQueue(label: "IntervalTimerAsyncQueue", qos: .default, attributes: .concurrent)
        let syncQueue = DispatchQueue(label: "IntervalTimerSyncQueue", qos: .userInitiated, attributes: .concurrent)
        // メインでループを回すと他の描画処理ができなくなるため，グローバルスレッドを利用
        asyncQueue.async {
            // グローバルスレッドでループを回すと完了を待たない。1つのループを回すため，グローバルスレッド内で同期処理を行う。
            syncQueue.sync {
                // 開始時間を格納
                let date = Date()
                self.date = (date, date)

                // isRunning中は
                while self.isRunning {
                    while self.isRunning && !self.isSleeping {
                        // 1 ms経過まで内部ループで待機する。
                        waitLoop: do {
                            // 待機ループカウントリセット
                            self.debugLoopValue.waitCount = 0
                            // 開始Dateから経過ミリ秒を加えた経過時間Dateを発行
                            self.date.prev = Date(timeInterval: Double(self.elapsed.milliseconds.now.value) / 1000, since: self.date.start)
                            // 待機ループ中に中断があるかの判断に(self.isRunning)
                            // 経過Dateから現在までの経過時刻を算出し，インターバル値を上回るまで待機ループ。
                            var tmpDate:Date = Date()
                            while tmpDate.timeIntervalSince(self.date.prev) <= (self.intervalMilliseconds) / 1000 {
                                // Discussion: self.isRunningを含めずとも終わるのでは？
                                // while (self.isRunning) && (tmpDate.timeIntervalSince(self.date.prev) <= (self.intervalMilliseconds)/1000) {
                                self.debugLoopValue.waitCount += 1
                                tmpDate = Date()
                            }
                            // 待機ループ脱出後，経過ミリ秒を更新
                            self.elapsed.milliseconds.previous = self.elapsed.milliseconds.now.value
                            self.elapsed.milliseconds.now.value = Int(tmpDate.timeIntervalSince(self.date.start) * 1000)
                            self.elapsed.date = tmpDate

                            self.checkDelay()
                        }

                        // ユーザーのflagを処理する。
                        decisionFlag: do {
                            if !self.isSleeping {
                                // スリープ時間が格納されていれば，その時間だけ通知を遅らせる。
                                if self.sleepStartMilliseconds != nil {
                                    let sleepTime = self.elapsed.milliseconds.now.value - self.sleepStartMilliseconds! + 2
                                    self.eventAlerm = self.eventAlerm.map {
                                        (id: $0.id, milliseconds: $0.milliseconds + sleepTime)
                                    }

                                    self.sleepStartMilliseconds = nil
                                }

                                // eventAlermの数だけ回し，evantAlermの時間が一致した場合，
                                for event in self.eventAlerm where event.milliseconds <= self.elapsed.milliseconds.now.value {
                                    // event idを，通知可能なeventFlag変数に入れる。
                                    self.eventFlag.value = event
                                    // イベントは破棄される。
                                    self.eventAlerm = self.eventAlerm.filter { $0 != event }
                                }

                            }
                        }
                        countup: do {
                            self.debugLoopValue.callCount += 1
                        }
                        debugPrint: do {
                            // Warning: Sleep復帰時に変更干渉が生じる。ここままでは使用不可。
                            //                            self.debugPrint()
                        }
                    }
                    while self.isRunning && self.isSleeping {
                        // Sleeping until wake up
                    }
                }
                self.isCompleted = true
            }
        }
    }
}

extension IntervalTimer {
    private func checkDelay() {
        //        DispatchQueue.global().async {
        //            // 最初は変動しうると仮定し，5秒遅延計測を無視。5秒後は遅延があったか(wait loopに突入したか)を判定
        //            if self.elapsed.milliseconds.now.value>=5*1000 {
        //                let delayCriterion:Int = self.intervalMilliseconds < 1 ? 2 : Int(self.intervalMilliseconds)+1
        //                if self.elapsed.milliseconds.now.value - self.elapsed.milliseconds.previous >= delayCriterion {
        //                    //print(self.elapsed.milliseconds.now.value - self.elapsed.milliseconds.previous)
        //                    // 遅延が生じていれば，連続遅延回数をカウントアップ
        //                    self.isDelayFlag.count += 1
        //                    // 連続遅延回数が設定値を超えたかを判定
        //                    if self.isDelayFlag.max != 0 && self.isDelayFlag.count >= self.isDelayFlag.max {
        //                        // 連続遅延数を検知した場合，
        //                        // 更新間隔を下げる。
        //                        changeInterval: do {
        //                            // 1ms計測，120fps計測の両者に対応可能な 0.05ms を基準とする。
        //                            self.intervalMilliseconds += 1 * 0.1
        //                            //print("指定されたインターバル値ではご利用いただけません。自動で値を(\(self.intervalMilliseconds))へ更新しました。")
        //                        }
        //                        self.isDelayFlag.count = 0
        //                    }
        //                }
        //            }
        //        }
    }

    private func debugPrint() {
        let seconds = Int(self.elapsed.milliseconds.now.value / 1000)
        if seconds != isRenewal.debug {
            isRenewal.debug = seconds
            self.debugText.value = """
            [\(#function)]
            Milliseconds: \(self.elapsed.milliseconds.now.value)
            Details     : \(Date().timeIntervalSince(date.start))
            Num of loops: \(self.debugLoopValue)
            Interval    : \(self.intervalMilliseconds)-ms
            FPS         : \(Int(1000 / self.intervalMilliseconds))
            """
            self.debugLoopValue.callCount = 1
            self.isDelayFlag.count = 0
        }
    }
}

public extension IntervalTimer {
    func sleep() {
        self.isSleeping = true
        self.sleepStartMilliseconds = self.elapsed.milliseconds.now.value
    }
    func wakeUp() {
        self.isSleeping = false
    }
    func finish() {
        self.isRunning = false
    }
}

public extension IntervalTimer {
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