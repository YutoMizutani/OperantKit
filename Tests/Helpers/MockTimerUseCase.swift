//
//  MockTimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/27.
//

import OperantKit
import RxSwift

class MockTimerUseCase: TimerUseCase {
    var milliseconds = PublishSubject<Milliseconds>()
    var priority: Priority
    private var value = 0

    init(priority: Priority) {
        self.priority = priority
    }
}

private extension MockTimerUseCase {
    func reset() {
        value = 0
    }

    func countUp() {
        value += 1
    }

    func set(_ v: Int) {
        value = v
    }
}

extension MockTimerUseCase {
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
