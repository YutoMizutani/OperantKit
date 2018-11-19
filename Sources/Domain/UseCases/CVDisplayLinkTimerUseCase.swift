//
//  CVDisplayLinkTimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

#if os(macOS) && canImport(QuartzCore)

import QuartzCore
import RxSwift

public class CVDisplayLinkTimerUseCase: TimerUseCase {
    // TODO: Update to `Milliseconds` type
    private typealias StackItem = (milliseconds: Int, closure: (() -> Void))
    private var lock = NSLock()
    private var stack: [StackItem] = []
    private var modifiedStartTime: UInt64 = 0
    private var startSleepTime: UInt64 = 0
    private var displayLink: CVDisplayLink!
    public var startTime: UInt64 = 0
    public var milliseconds: PublishSubject<Int> = PublishSubject<Int>()
    /// Not supported yet
    public var priority: Priority = .default

    public init() {}
}

private extension CVDisplayLinkTimerUseCase {
    /// Set timer event
    func addEvent(_ milliseconds: Int, _ closure: @escaping (() -> Void)) {
        lock.lock()
        defer { lock.unlock() }
        self.stack.append((milliseconds, closure))
    }

    /// Execute evetns
    func executeEvents(_ elapsed: Int) {
        for event in self.stack where event.milliseconds <= elapsed {
            event.closure()
        }
    }

    /// Remove timer events
    func removeEvent(_ milliseconds: Int) {
        lock.lock()
        defer { lock.unlock() }
        self.stack = self.stack.filter { $0.milliseconds > milliseconds }
    }

    /// Get elapsed time milliseconds
    func getElapsedMilliseconds() -> Int {
        return Int((mach_absolute_time() - modifiedStartTime) / 1_000_000)
    }

    /// Get elapsed time milliseconds
    func getElapsed(with time: UInt64) -> Int {
        return Int((time - modifiedStartTime) / 1_000_000)
    }

    /// Update time with main loop
    func updateTime(_ displaylink: CVDisplayLink) {
        let elapsed: Int = getElapsedMilliseconds()
        milliseconds.onNext(elapsed)
        executeEvents(elapsed)
    }
}

public extension CVDisplayLinkTimerUseCase {
    func start() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let displayID = CGMainDisplayID()
            CVDisplayLinkCreateWithCGDisplay(displayID, &self.displayLink)
            CVDisplayLinkSetOutputHandler(self.displayLink, { [weak self] displayLink, _, _, _, _ -> CVReturn in
                self?.updateTime(displayLink)
                return kCVReturnSuccess
            })
            self.startTime = mach_absolute_time()
            self.modifiedStartTime = self.startTime
            CVDisplayLinkStart(self.displayLink)
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

            CVDisplayLinkStop(self.displayLink)
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
            CVDisplayLinkStart(self.displayLink)
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
            CVDisplayLinkStop(self.displayLink)
            self.displayLink = nil
            single(.success(finishedTime))

            return Disposables.create()
        }
    }
}

#endif
