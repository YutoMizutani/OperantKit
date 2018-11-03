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

public func VR(_ value: Int, iterations: Int = 12) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(value: value, iterations: iterations)
}

public func FI(_ value: Int, unit: TimeUnit = .seconds) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(value: value, unit: unit)
}

public func VI(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableIntervalScheduleUseCase {
    return VariableIntervalScheduleUseCase(value: value, unit: unit, iterations: iterations)
}
