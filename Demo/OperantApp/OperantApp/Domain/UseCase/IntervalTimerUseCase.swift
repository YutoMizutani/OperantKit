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

    func start() -> Completable {
        return Completable.create { completable in
            guard let timer = self.timer else {
                completable(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.start()
            completable(.completed)

            return Disposables.create()
        }
    }

    func getInterval() -> Single<Int> {
        return Single.create { single in
            guard let timer = self.timer else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(timer.elapsed.milliseconds.value))

            return Disposables.create()
        }
    }

    func pause() -> Completable {
        return Completable.create { completable in
            guard let timer = self.timer else {
                completable(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.sleep()
            completable(.completed)

            return Disposables.create()
        }
    }

    func finish() -> Completable {
        return Completable.create { completable in
            guard let timer = self.timer else {
                completable(.error(RxError.noElements))
                return Disposables.create()
            }

            timer.finish()
            completable(.completed)

            return Disposables.create()
        }
    }
}
