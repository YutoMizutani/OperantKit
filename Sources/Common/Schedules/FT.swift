//
//  FT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Fixed time schedule
    public func FT(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return fixedTime(value)
    }

    /// FT logic
    func fixedTime(_ value: Single<Milliseconds>) -> Observable<Bool> {
        return flatMap { a in value.map { a.milliseconds >= $0 } }
    }
}
