//
//  ResultEntity+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension Observable where Element == ResultEntity {
    func clearResponse(_ entity: ResponseEntity, condition: @escaping ((Element) -> Bool)) -> Observable<Element> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.numberOfResponses = 0
            entity.milliseconds = 0
        })
    }

    func storeResponse(_ entity: ResponseEntity, condition: @escaping ((Element) -> Bool)) -> Observable<Element> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.numberOfResponses = $0.entity.numberOfResponses
            entity.milliseconds = $0.entity.milliseconds
        })
    }

    func nextOrder(_ entity: VariableEntity, condition: @escaping ((Element) -> Bool)) -> Observable<Element> {
        return self.do(onNext: {
            guard condition($0) else { return }
            let nextOrder = entity.order + 1
            entity.order = nextOrder < entity.values.count ? nextOrder : 0
        })
    }

    func nextRandom(_ entity: RandomEntity, condition: @escaping ((Element) -> Bool)) -> Observable<Element> {
        return self.do(onNext: {
            guard condition($0) else { return }
            entity.nextValue = entity.displayValue <= 0 ? 0 : Int.random(in: 1...entity.displayValue)
        })
    }
}
