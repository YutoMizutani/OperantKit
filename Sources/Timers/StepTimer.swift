//
//  StepTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public class StepTimer: SessionTimer {
    private var milliseconds = PublishSubject<Milliseconds>()
    private var value = 0
    private var step: Int
    private var totalSleepTime: Milliseconds = 0
    /// - Note: Not supported yet
    public var priority: Priority = .default
    public var realTime: Observable<RealTime> { milliseconds.map { RealTime($0) } }
    public var sessionTime: Observable<SessionTime> { milliseconds.map { [unowned self] in SessionTime($0 - self.totalSleepTime) } }

    public init(_ step: Int = 1) {
        self.step = step
    }

    private func sessionTime(from realTime: RealTime) -> SessionTime {
        SessionTime(realTime.value - totalSleepTime)
    }
}

private extension StepTimer {
    func reset() {
        value = 0
    }

    func countUp() {
        value += step
    }

    func set(_ v: Int) {
        value = v
    }
}

public extension StepTimer {
    func start() -> PrimitiveSequence<SingleTrait, ()> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.reset()
            single(.success(()))

            return Disposables.create()
        }
    }

    func elapsed() -> PrimitiveSequence<SingleTrait, SessionTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.countUp()
            single(.success(self.sessionTime(from: RealTime(self.value))))

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
            self.set(milliseconds)
            single(.success(RealTime(milliseconds)))

            return Disposables.create()
        }
    }

    func pause() -> PrimitiveSequence<SingleTrait, RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(RealTime(self.value)))

            return Disposables.create()
        }
    }

    func resume() -> PrimitiveSequence<SingleTrait, RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(RealTime(self.value)))

            return Disposables.create()
        }
    }

    func finish() -> PrimitiveSequence<SingleTrait, RealTime> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(RealTime(self.value)))

            return Disposables.create()
        }
    }
}
