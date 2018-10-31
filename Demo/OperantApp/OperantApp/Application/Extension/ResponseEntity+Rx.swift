//
//  ResponseEntity+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/31.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxSwift

public extension Observable where E == ResponseEntity {
    func fromLastResponse(_ entity: E) -> Observable<E> {
        return self.map { $0 - entity }
    }
}
