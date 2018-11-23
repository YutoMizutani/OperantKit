//
//  ExtinctionScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public struct ExtinctionScheduleUseCase: ScheduleUseCase {
    public weak var repository: ScheduleRespository?

    public var scheduleType: ScheduleType {
        return .extinction
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool = true) -> Observable<ResultEntity> {
        return observer.EXT()
    }
}
