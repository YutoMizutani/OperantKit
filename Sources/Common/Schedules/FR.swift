//
//  FR5.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed ratio schedule
    public func FR(_ value: Single<Int>) -> Observable<Bool> {
        return fixedRatio(value)
    }

    /// FR logic
    func fixedRatio(_ value: Single<Int>) -> Observable<Bool> {
        return flatMap { a in value.map { a.numOfResponses >= $0 } }
    }
}
