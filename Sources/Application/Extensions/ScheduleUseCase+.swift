//
//  ScheduleUseCase+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

// MARK: - Builders without class

/// - Tag: EXT()
public func EXT(repository: ScheduleRespository = ScheduleRespositoryImpl()) -> ExtinctionScheduleUseCase {
    return ExtinctionScheduleUseCase(repository)
}

/// - Tag: CRF()
public func CRF(repository: ScheduleRespository = ScheduleRespositoryImpl(value: 1)) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(repository)
}

/// - Tag: FR()
public func FR(repository: ScheduleRespository) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(repository)
}

/// - Tag: FR()
public func FR(_ value: Int) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(
        ScheduleRespositoryImpl(value: value)
    )
}

public func VR(repository: ScheduleRespository) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(repository)
}

public func VR(_ value: Int, iterations: Int = 12) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: FleshlerHoffman().generatedRatio(
                value: value,
                iterations: iterations
            )
        )
    )
}

public func VR(_ value: Int, values: [Int]) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RR(repository: ScheduleRespository) -> RandomRatioScheduleUseCase {
    return RandomRatioScheduleUseCase(repository)
}

public func RR(_ value: Int) -> RandomRatioScheduleUseCase {
    return RandomRatioScheduleUseCase(
        ScheduleRespositoryImpl(parameter: Parameter.random(value))
    )
}

public func FI(repository: ScheduleRespository) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(repository)
}

public func FI(_ value: Int, unit: TimeUnit = .seconds) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(
        ScheduleRespositoryImpl(value: unit.milliseconds(value))
    )
}

public func VI(repository: ScheduleRespository) -> VariableIntervalScheduleUseCase {
    return VariableIntervalScheduleUseCase(repository)
}

public func VI(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableIntervalScheduleUseCase {
    let value = unit.milliseconds(value)
    return VariableIntervalScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: FleshlerHoffman().generatedInterval(
                value: value,
                iterations: iterations
            )
        )
    )
}

public func VI(_ value: Int, values: [Int]) -> VariableIntervalScheduleUseCase {
    return VariableIntervalScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RI(repository: ScheduleRespository) -> RandomIntervalScheduleUseCase {
    return RandomIntervalScheduleUseCase(repository)
}

public func RI(_ value: Int, unit: TimeUnit = .seconds) -> RandomIntervalScheduleUseCase {
    let value = unit.milliseconds(value)
    return RandomIntervalScheduleUseCase(
        ScheduleRespositoryImpl(parameter: Parameter.random(value))
    )
}

public func FT(repository: ScheduleRespository) -> FixedTimeScheduleUseCase {
    return FixedTimeScheduleUseCase(repository)
}

public func FT(_ value: Int, unit: TimeUnit = .seconds) -> FixedTimeScheduleUseCase {
    return FixedTimeScheduleUseCase(
        ScheduleRespositoryImpl(value: unit.milliseconds(value))
    )
}

public func VT(repository: ScheduleRespository) -> VariableTimeScheduleUseCase {
    return VariableTimeScheduleUseCase(repository)
}

public func VT(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableTimeScheduleUseCase {
    let value = unit.milliseconds(value)
    return VariableTimeScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: FleshlerHoffman().generatedInterval(
                value: value,
                iterations: iterations
            )
        )
    )
}

public func VT(_ value: Int, values: [Int]) -> VariableTimeScheduleUseCase {
    return VariableTimeScheduleUseCase(
        ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RT(repository: ScheduleRespository) -> RandomTimeScheduleUseCase {
    return RandomTimeScheduleUseCase(repository)
}

public func RT(_ value: Int, unit: TimeUnit = .seconds) -> RandomTimeScheduleUseCase {
    let value = unit.milliseconds(value)
    return RandomTimeScheduleUseCase(ScheduleRespositoryImpl(parameter: Parameter.random(value)))
}

public func Alt(_ subSchedules: ScheduleUseCase...) -> AlternativeScheduleUseCase {
    return AlternativeScheduleUseCase(subSchedules)
}

public func Alt(_ subSchedules: [ScheduleUseCase]) -> AlternativeScheduleUseCase {
    return AlternativeScheduleUseCase(subSchedules)
}

public func Conc(_ subSchedules: [ScheduleUseCase]) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(subSchedules)
}

public func Conc(_ subSchedules: ScheduleUseCase...) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(subSchedules)
}

public func Conc(_ sharedSchedule: Shared<ScheduleUseCase>) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(sharedSchedule)
}
