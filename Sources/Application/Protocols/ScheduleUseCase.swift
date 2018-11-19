//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public protocol ScheduleUseCase {
    var scheduleType: ScheduleType { get }
    var extendEntity: ResponseEntity { get }

    func decision(_: Observable<ResponseEntity>) -> Observable<ReinforcementResult>
}
