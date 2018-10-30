//
//  IntervalTimerUseCase.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxSwift

struct IntervalTimerUseCase {
    private var timer: IntervalTimer?

    init(timer: IntervalTimer? = nil) {
        self.timer = timer ?? IntervalTimer()
    }

    func start() -> Single<Void> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.start()
            single(.success(()))

            return Disposables.create()
        }
    }

    func getInterval() -> Single<Int> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(timer.milliseconds))

            return Disposables.create()
        }
    }

    func delay(_ value: Int, currentTime: Int) -> Single<Int> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let time = currentTime + value
            timer.addEvent(({
                single(.success(timer.milliseconds))
            }, time))

            return Disposables.create()
        }
    }

    func delay(_ value: Int) -> Single<Int> {
        return getInterval()
            .flatMap { currentTime in
                Single.create { single in
                    guard let timer = self.timer else {
                        single(.error(RxError.noElements))
                        return Disposables.create()
                    }

                    let time = currentTime + value
                    timer.addEvent(({
                        single(.success(timer.milliseconds))
                    }, time))

                    return Disposables.create()
                }
            }
    }

    func pause() -> Single<Void> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.sleep()
            single(.success(()))

            return Disposables.create()
        }
    }

    func resume() -> Single<Void> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.wakeUp()
            single(.success(()))

            return Disposables.create()
        }
    }

    func finish() -> Single<Void> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.finish()
            single(.success(()))

            return Disposables.create()
        }
    }
}
