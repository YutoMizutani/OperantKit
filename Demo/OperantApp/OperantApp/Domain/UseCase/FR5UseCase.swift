//
//  FR5UseCase.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxSwift

protocol ScheduleUseCase {
    func decision(_ entity: ResponseEntity) -> Single<Bool>
}

struct FR5UseCase: ScheduleUseCase {
    let parameter = FixedRatioParameter(value: 5)
    let schedule = FixedRatioSchedule()

    func decision(_ entity: ResponseEntity) -> Single<Bool> {
        return Single.create { single in
            single(.success(self.schedule.decision(entity.numOfResponse, value: self.parameter.value)))

            return Disposables.create()
        }
    }
}
