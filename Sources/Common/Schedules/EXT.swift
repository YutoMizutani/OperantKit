//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func extinction() -> Observable<Consequence> {
        return asObservable()
            .map { .none($0) }
    }
}
