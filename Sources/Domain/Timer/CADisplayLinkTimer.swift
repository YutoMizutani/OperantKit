//
//  CADisplayLinkTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

#if os(iOS) || os(tvOS)

import QuartzCore
import RxSwift

public class CADisplayLinkTimer: SessionTimer {
    private typealias StackItem = (milliseconds: Milliseconds, closure: (() -> Void))
    private var lock = NSLock()
    private var stack: [StackItem] = []
    private var modifiedStartTime: UInt64 = 0
    private var startSleepTime: UInt64 = 0
    private var displayLink: CADisplayLink!
    public var startTime: UInt64 = 0
    public var priority: Priority
    public var milliseconds: PublishSubject<Milliseconds> = PublishSubject<Milliseconds>()

    public init(priority: Priority = .default) {
        self.priority = priority
        _ = TimeHelper.shared
    }
}

private extension CADisplayLinkTimer {
    /// Set timer event
    func addEvent(_ milliseconds: Milliseconds, _ closure: @escaping (() -> Void)) {
        lock.lock()
        defer { lock.unlock() }
        self.stack.append((milliseconds, closure))
    }

    /// Execute evetns
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

    /// Update time with main loop
    @objc
    func updateTime(_ displaylink: CADisplayLink) {
        let elapsed: Milliseconds = getElapsedMilliseconds()
        milliseconds.onNext(elapsed)
        executeEvents(elapsed)
    }
}

public extension CADisplayLinkTimer {
    func start() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.displayLink = CADisplayLink(target: self, selector: #selector(self.updateTime(_:)))
            switch self.priority {
            case .immediate:
                self.displayLink.preferredFramesPerSecond = 0
            case .high:
                self.displayLink.preferredFramesPerSecond = 120
            case .default:
                self.displayLink.preferredFramesPerSecond = 60
            case .low:
                self.displayLink.preferredFramesPerSecond = 30
            case .manual(let v):
                self.displayLink.preferredFramesPerSecond = Int(v)
            }
            self.startTime = mach_absolute_time()
            self.modifiedStartTime = self.startTime
            self.displayLink?.add(to: .current, forMode: .default)
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

            self.displayLink?.isPaused = true
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
            self.displayLink?.isPaused = false
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
            self.displayLink = nil
            single(.success(finishedTime))

            return Disposables.create()
        }
    }
}

#endif
