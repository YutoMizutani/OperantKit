//
//  ObservableType+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift

public extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            #if DEBUG
            assertionFailure("Error \(error)")
            #endif
            return Driver.empty()
        }
    }
}

public extension ObservableType {
    /// Count up
    func count() -> Observable<Int> {
        return scan(0) { n, _ in n + 1 }
    }

    /// Get time
    func getTime(_ timer: TimerUseCase) -> Observable<Milliseconds> {
        return flatMap { _ in timer.elapsed() }
    }

    /// Response entity
    func response(_ timer: TimerUseCase) -> Observable<ResponseEntity> {
        return Observable.zip(count(), getTime(timer))
            .map { ResponseEntity(numOfResponses: $0.0, milliseconds: $0.1) }
    }
}
