//
//  ObservableType+.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
}
