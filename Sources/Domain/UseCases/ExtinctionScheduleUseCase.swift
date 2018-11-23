//
//  ExtinctionScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct ExtinctionScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .extinction
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        return observer.EXT()
    }
}
