//
//  FR5.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// function外で管理する
    public func FR(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .fixedRatio(value, entity)
    }

    /// FR logic
    func fixedRatio(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return self.map { (($0.numOfResponse >= value + entity.numOfResponse), $0) }
    }
}
