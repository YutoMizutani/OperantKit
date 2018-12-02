//
//  StepTimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public class StepTimerUseCase: TimerUseCase {
    /// - Note: Not supported yet
    public var priority: Priority = .default
    public var milliseconds = PublishSubject<Milliseconds>()
    private var value = 0
    private var step: Int

    public init(_ step: Int = 1) {
        self.step = step
    }
}

private extension StepTimerUseCase {
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

public extension StepTimerUseCase {
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

    func elapsed() -> PrimitiveSequence<SingleTrait, Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.countUp()
            single(.success(self.value))

            return Disposables.create()
        }
    }

    func delay(_ value: Int, currentTime: Int) -> PrimitiveSequence<SingleTrait, Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let v = value + currentTime
            self.set(v)
            single(.success(v))

            return Disposables.create()
        }
    }

    func pause() -> PrimitiveSequence<SingleTrait, Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.value))

            return Disposables.create()
        }
    }

    func resume() -> PrimitiveSequence<SingleTrait, Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.value))

            return Disposables.create()
        }
    }

    func finish() -> PrimitiveSequence<SingleTrait, Int> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.value))

            return Disposables.create()
        }
    }
}
