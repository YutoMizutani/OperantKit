//
//  VR.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Variable ratio schedule
    public func VR(_ value: Int, with entity: E) -> Observable<ReinforcementResult> {
        return self
            .variableRatio(value, entity)
    }

    /// VR logic
    func variableRatio(_ value: Int, _ entity: E) -> Observable<ReinforcementResult> {
        return fixedRatio(value, entity)
    }
}
