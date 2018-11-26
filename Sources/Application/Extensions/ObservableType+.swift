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
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

    func store(startWith: Self.E) -> Observable<(newValue: E, oldValue: E)> {
        return Observable.zip(self, self.startWith(startWith)).map { (newValue: $0.0, oldValue: $0.1) }
    }

    func store() -> Observable<(newValue: E, oldValue: E?)> {
        return Observable.zip(self, self.map(Optional.init).startWith(nil)).map { (newValue: $0.0, oldValue: $0.1) }
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
        return count()
            .flatMapLatest { numOfResponses in
                self.getTime(timer)
                    .map { milliseconds in
                        ResponseEntity(numOfResponses, milliseconds)
                    }
            }
    }
}
