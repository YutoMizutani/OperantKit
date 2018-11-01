//
//  ReinforcementResult+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension Observable where E == ReinforcementResult {
    func storeRespinse(_ entity: ResponseEntity) -> Observable<E> {
        return self.do(onNext: {
            guard $0.isReinforcement else { return }
            entity.numOfResponse += $0.entity.numOfResponse
            entity.milliseconds = $0.entity.milliseconds
        })
    }
}
