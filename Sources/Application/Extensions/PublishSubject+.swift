//
//  PublishSubject+.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxCocoa
import RxSwift

public extension PublishSubject where E == Milliseconds {
    /// Optimized time
    var shared: Observable<E> {
        return distinctUntilChanged()
            .share(replay: 1)
    }

    /// Translate to response entity
    func asResponse() -> Driver<ResponseEntity> {
        return distinctUntilChanged()
            .map { ResponseEntity(numOfResponses: 0, milliseconds: $0) }
            .asDriverOnErrorJustComplete()
    }
}
