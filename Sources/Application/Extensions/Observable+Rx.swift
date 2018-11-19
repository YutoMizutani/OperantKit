//
//  RxSwift+.swift
//  OperantKit iOS
//
//  Created by Yuto Mizutani on 2018/10/22.
//

import RxSwift

public extension Observable {
    func extend(response numOfResponse: Int, entities: [ResponseEntity]) -> Observable<E> {
        return self.do(onNext: { _ in
            for entity in entities {
                entity.numOfResponse += numOfResponse
            }
        })
    }

    func extend(time milliseconds: Milliseconds, entities: [ResponseEntity]) -> Observable<E> {
        return self.do(onNext: { _ in
            for entity in entities {
                entity.milliseconds += milliseconds
            }
        })
    }

    func extend(entity e: ResponseEntity, entities: [ResponseEntity]) -> Observable<E> {
        return self.do(onNext: { _ in
            for entity in entities {
                entity.numOfResponse += e.numOfResponse
                entity.milliseconds += e.milliseconds
            }
        })
    }
}
