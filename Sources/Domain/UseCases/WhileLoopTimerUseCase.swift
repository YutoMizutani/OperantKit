//
//  WhileLoopTimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation
import RxSwift

public class WhileLoopTimerUseCase: TimerUseCase {
    private typealias StackItem = (milliseconds: Milliseconds, closure: (() -> Void))
    private let asyncQueue = DispatchQueue(label: "WhileLoopTimerAsyncQueue", qos: .default, attributes: .concurrent)
    private let syncQueue = DispatchQueue(label: "WhileLoopTimerSyncQueue", qos: .userInitiated, attributes: .concurrent)
    private var lock = NSLock()
    private var stack: [StackItem] = []
    private var modifiedStartTime: UInt64 = 0
    private var startSleepTime: UInt64 = 0
    public var startTime: UInt64 = 0
    public var isRunning = true
    public var isPaused = false
    public var milliseconds: PublishSubject<Milliseconds> = PublishSubject<Milliseconds>()
    public var priority: Priority

    public init(priority: Priority = .default) {
        self.priority = priority
        _ = TimeHelper.shared
    }
}

private extension WhileLoopTimerUseCase {
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
        return (mach_absolute_time() - modifiedStartTime).milliseconds
    }

    /// Get elapsed time milliseconds
    func getElapsed(with time: UInt64) -> Milliseconds {
        return (time - modifiedStartTime).milliseconds
    }

    /// Run loop
    func runLoop() {
        while isRunning {
            guard !isPaused else { continue }
            let elapsed = getElapsedMilliseconds()
            milliseconds.onNext(elapsed)
            executeEvents(elapsed)
            switch priority {
            case .immediate:
                continue
            case .high:
                usleep(100)
            case .default:
                usleep(1_000)
            case .low:
                usleep(100_000)
            }
        }
    }
}

public extension WhileLoopTimerUseCase {
    func start() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.startTime = mach_absolute_time()
            self.modifiedStartTime = self.startTime
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

    func elapsed() -> Single<Milliseconds> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.getElapsedMilliseconds()))

            return Disposables.create()
        }
    }

    func delay(_ value: Milliseconds, currentTime: Milliseconds) -> Single<Milliseconds> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let milliseconds = value + currentTime
            self.stack.append((milliseconds, {
                single(.success(milliseconds))
            }))

            return Disposables.create()
        }
    }

    func pause() -> Single<Milliseconds> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.isPaused = true
            let paused = mach_absolute_time()
            self.startSleepTime = paused
            single(.success(self.getElapsed(with: paused)))

            return Disposables.create()
        }
    }

    func resume() -> Single<Milliseconds> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let resumed = mach_absolute_time()
            self.modifiedStartTime -= resumed - self.startSleepTime
            self.isPaused = false
            single(.success(self.getElapsed(with: resumed)))

            return Disposables.create()
        }
    }

    func finish() -> Single<Milliseconds> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let finishedTime = self.getElapsedMilliseconds()
            self.isRunning = false
            single(.success(finishedTime))

            return Disposables.create()
        }
    }
}
