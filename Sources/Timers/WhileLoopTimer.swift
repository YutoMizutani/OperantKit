//
//  WhileLoopTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

public class WhileLoopTimer: SessionTimer {
    private typealias StackItem = (milliseconds: Milliseconds, closure: (() -> Void))
    private let asyncQueue = DispatchQueue(label: "WhileLoopTimerAsyncQueue", qos: .default, attributes: .concurrent)
    private let syncQueue = DispatchQueue(label: "WhileLoopTimerSyncQueue", qos: .userInitiated, attributes: .concurrent)
    private var lock = NSLock()
    private var milliseconds: PublishSubject<Milliseconds> = PublishSubject<Milliseconds>()
    private var stack: [StackItem] = []
    private var totalSleepTime: Milliseconds = 0
    private var startSleepTime: UInt64 = 0
    public var startTime: UInt64 = 0
    public var isRunning = true
    public var isPaused = false
    public var priority: Priority
    public var realTime: Observable<RealTime> { milliseconds.map { RealTime($0) } }
    public var sessionTime: Observable<SessionTime> { milliseconds.map { [unowned self] in SessionTime($0 - self.totalSleepTime) } }

    public init(priority: Priority = .default) {
        self.priority = priority
        _ = TimeHelper.shared
    }

    private func sessionTime(from realTime: RealTime) -> SessionTime {
        SessionTime(realTime.value - totalSleepTime)
    }
}

private extension WhileLoopTimer {
    /// Set timer event
    func addEvent(_ milliseconds: Milliseconds, _ closure: @escaping (() -> Void)) {
        lock.lock()
        defer { lock.unlock() }
        stack.append((milliseconds, closure))
    }

    /// Execute events
    func executeEvents(_ elapsed: Milliseconds) {
        for event in self.stack where event.milliseconds <= elapsed {
            event.closure()
        }
    }

    /// Remove timer events
    func removeEvent(_ milliseconds: Milliseconds) {
        lock.lock()
        defer { lock.unlock() }
        self.stack = self.stack.filter { $0.milliseconds > milliseconds }
    }

    /// Get elapsed time milliseconds
    func getElapsedMilliseconds() -> Milliseconds {
        return mach_absolute_time().milliseconds - totalSleepTime
    }

    /// Get elapsed time milliseconds
    func getElapsed(with time: UInt64) -> Milliseconds {
        return time.milliseconds - totalSleepTime
    }

    /// Get sleep time
    private func getSleepTime(_ priority: Priority) -> UInt32? {
        switch priority {
        case .immediate:
            return nil
        case .high:
            return 100
        case .default:
            return 1_000
        case .low:
            return 100_000
        case .manual(let v):
            return v
        }
    }

    /// Run loop
    func runLoop() {
        let sleepTime = getSleepTime(priority)
        let sleep: () -> Void = sleepTime != nil ? { usleep(sleepTime!) } : {}

        while isRunning {
            guard !isPaused else { continue }
            let elapsed = getElapsedMilliseconds()
            milliseconds.onNext(elapsed)
            executeEvents(elapsed)
            sleep()
        }
    }
}

public extension WhileLoopTimer {
    func start() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.startTime = mach_absolute_time()
            self.totalSleepTime = 0
            self.isRunning = true
            self.asyncQueue.async { [unowned self] in
                self.syncQueue.sync { [unowned self] in
                    self.runLoop()
                }
            }
            single(.success(()))

            return Disposables.create()
        }
    }

    func elapsed() -> Single<SessionTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.sessionTime(from: RealTime(self.getElapsedMilliseconds()))))

            return Disposables.create()
        }
    }

    func delay(_ value: Milliseconds, currentTime: SessionTime) -> Single<RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let milliseconds = value + currentTime.value
            self.stack.append((milliseconds, {
                single(.success(RealTime(milliseconds)))
            }))

            return Disposables.create()
        }
    }

    func pause() -> Single<RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.isPaused = true
            let paused = mach_absolute_time()
            self.startSleepTime = paused
            single(.success(RealTime(self.getElapsed(with: paused))))

            return Disposables.create()
        }
    }

    func resume() -> Single<RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let resumed = mach_absolute_time()
            self.totalSleepTime += (resumed - self.startSleepTime).milliseconds
            self.isPaused = false
            single(.success(RealTime(self.getElapsed(with: resumed))))

            return Disposables.create()
        }
    }

    func finish() -> Single<RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let finishedTime = self.getElapsedMilliseconds()
            self.isRunning = false
            single(.success(RealTime(finishedTime)))

            return Disposables.create()
        }
    }
}
