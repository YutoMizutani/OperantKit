//
//  PublishSubject+.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public extension PublishSubject where Element == Milliseconds {
    /// Optimized time
    var shared: Observable<Element> {
        return distinctUntilChanged()
            .share(replay: 1)
    }
}
