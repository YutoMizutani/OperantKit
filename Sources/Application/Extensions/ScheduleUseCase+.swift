//
//  ScheduleUseCase+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public func EXT() -> ExtinctionScheduleUseCase {
    return ExtinctionScheduleUseCase()
}

public func CRF() -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(value: 1)
}

public func FR(_ value: Int) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(value: value)
}

public func VR(_ value: Int, iterations: Int = 12) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(value: value, iterations: iterations)
}

public func VR(_ value: Int, values: [Int]) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(value: value, values: values)
}

public func RR(_ value: Int) -> RandomRatioScheduleUseCase {
    return RandomRatioScheduleUseCase(value: value)
}

public func FI(_ value: Int, unit: TimeUnit = .seconds) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(value: value, unit: unit)
}

public func VI(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableIntervalScheduleUseCase {
    return VariableIntervalScheduleUseCase(value: value, unit: unit, iterations: iterations)
}

public func RI(_ value: Int, unit: TimeUnit = .seconds) -> RandomIntervalScheduleUseCase {
    return RandomIntervalScheduleUseCase(value: value, unit: unit)
}

public func FT(_ value: Int, unit: TimeUnit = .seconds) -> FixedTimeScheduleUseCase {
    return FixedTimeScheduleUseCase(value: value, unit: unit)
}

public func VT(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableTimeScheduleUseCase {
    return VariableTimeScheduleUseCase(value: value, unit: unit, iterations: iterations)
}

public func RT(_ value: Int, unit: TimeUnit = .seconds) -> RandomTimeScheduleUseCase {
    return RandomTimeScheduleUseCase(value: value, unit: unit)
}

public func Conc(_ subSchedules: ScheduleUseCase...) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(subSchedules: subSchedules, isShared: false)
}

public func Conc(_ sharedSchedule: Shared<ScheduleUseCase>) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(sharedSchedule)
}
