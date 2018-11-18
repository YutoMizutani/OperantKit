//
//  MainTimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

#if os(iOS) || os(tvOS) || os(watchOS)

import QuartzCore
import RxCocoa
import RxSwift

public class MainTimerUseCase: TimerUseCase {
    // TODO: Update to `Milliseconds` type
    private typealias StackItem = (milliseconds: Int, closure: (() -> Void))
    private var lock = NSLock()
    private var stack: [StackItem] = []
    private var modifiedStartTime: UInt64 = 0
    private var startSleepTime: UInt64 = 0
    private var displayLink: CADisplayLink?
    public var startTime: UInt64 = 0
    public var milliseconds: PublishSubject<Int> = PublishSubject<Int>()

    public init() {}

    /// Set timer event
    public func addEvent(_ milliseconds: Int, _ closure: @escaping (() -> Void)) {
        lock.lock()
        defer { lock.unlock() }
        self.stack.append((milliseconds, closure))
    }

    private func executeEvent(_ elapsed: Int) {
        for event in self.stack where event.milliseconds <= elapsed {
            event.closure()
        }
    }

    /// Remove timer events
    private func removeEvent(_ milliseconds: Int) {
        lock.lock()
        defer { lock.unlock() }
        self.stack = self.stack.filter { $0.milliseconds > milliseconds }
    }

    /// Get elapsed time milliseconds
    private func getElapsedMilliseconds() -> Int {
        return Int((mach_absolute_time() - modifiedStartTime) / 1_000_000)
    }

    /// Get elapsed time milliseconds
    private func getElapsed(with time: UInt64) -> Int {
        return Int((time - modifiedStartTime) / 1_000_000)
    }

    @objc
    private func updateTime(_ displaylink: CADisplayLink) {
        let elapsed: Int = getElapsedMilliseconds()
        milliseconds.onNext(elapsed)
        executeEvent(elapsed)
    }
}

public extension MainTimerUseCase {
    func start() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.startTime = mach_absolute_time()
            self.modifiedStartTime = self.startTime
            self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateTime(_:)))
            self.displayLink?.add(to: .current, forMode: .default)
            single(.success(()))

            return Disposables.create()
        }
    }

    func elapsed() -> Single<Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.getElapsedMilliseconds()))

            return Disposables.create()
        }
    }

    func delay(_ value: Int, currentTime: Int) -> Single<Int> {
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

    func pause() -> Single<Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let paused = mach_absolute_time()
            self.startSleepTime = paused
            single(.success(self.getElapsed(with: paused)))

            return Disposables.create()
        }
    }

    func resume() -> Single<Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let resumed = mach_absolute_time()
            self.modifiedStartTime -= resumed - self.startSleepTime
            single(.success(self.getElapsed(with: resumed)))

            return Disposables.create()
        }
    }

    func finish() -> Single<Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let finishedTime = self.getElapsedMilliseconds()
            self.displayLink = nil
            single(.success(finishedTime))

            return Disposables.create()
        }
    }
}

#endif
