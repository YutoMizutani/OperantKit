//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public protocol ScheduleUseCase {
    func decision(_: Observable<ResponseEntity>) -> Observable<ReinforcementResult>
}

public func EXT() -> ExtinctionScheduleUseCase {
    return ExtinctionScheduleUseCase()
}

public func FR(_ value: Int) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(value: value)
}

public func VR(_ value: Int) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(value: value)
}
