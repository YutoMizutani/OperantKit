//
//  ReinforcementResult+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension Observable where E == ReinforcementResult {
    func clearResponse(_ entity: ResponseEntity, condition: @escaping ((E) -> Bool)) -> Observable<E> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.numOfResponse = 0
            entity.milliseconds = 0
        })
    }

    func storeResponse(_ entity: ResponseEntity, condition: @escaping ((E) -> Bool)) -> Observable<E> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.numOfResponse = $0.entity.numOfResponse
            entity.milliseconds = $0.entity.milliseconds
        })
    }

    func nextOrder(_ entity: VariableEntity, condition: @escaping ((E) -> Bool)) -> Observable<E> {
        return self.do(onNext: {
            guard condition($0) else { return }
            let nextOrder = entity.order + 1
            entity.order = nextOrder < entity.values.count ? nextOrder : 0
        })
    }

    func nextRandom(_ entity: RandomEntity, condition: @escaping ((E) -> Bool)) -> Observable<E> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.nextValue = RandomGenerator().generate(entity.displayValue)
        })
    }
}
