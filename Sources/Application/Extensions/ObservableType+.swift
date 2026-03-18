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
    /// Map from any to void
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    /// Translate from Observable to Driver on error just complete
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }

    /// Store the last response and return tuple
    func store(startWith: Element) -> Observable<(newValue: Element, oldValue: Element)> {
        let shared = self.share(replay: 1, scope: .whileConnected)
        return Observable.zip(shared, shared.startWith(startWith)) { a, b in
            (newValue: a, oldValue: b)
        }
    }

    /// Store the last response and return tuple
    func store() -> Observable<(newValue: Element, oldValue: Element?)> {
        let shared = self.share(replay: 1, scope: .whileConnected)
        return Observable.zip(shared, shared.map(Optional.init).startWith(nil)) { a, b in
            (newValue: a, oldValue: b)
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
        let shared = self.share(replay: 1, scope: .whileConnected)
        return Observable.zip(shared.count(), shared.getTime(timer)) { a, b in
            ResponseEntity(a, b)
        }
    }
}
