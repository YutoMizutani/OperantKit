//
//  FI.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public extension Observable where E == ResponseEntity {
    func FI(_ value: Int, unit: TimeUnit) -> Observable<Bool> {
        return self.map { $0.milliseconds >= unit.milliseconds(value) }
    }
}
