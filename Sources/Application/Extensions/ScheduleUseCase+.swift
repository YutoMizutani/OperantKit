//
//  ScheduleUseCase+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

// MARK: - Builders without class

/// - Tag: EXT()
public func EXT(repository: ScheduleRespository = ScheduleRespositoryImpl(value: 0, values: [])) -> ExtinctionScheduleUseCase {
    return ExtinctionScheduleUseCase(repository: repository)
}

/// - Tag: CRF()
public func CRF(repository: ScheduleRespository = ScheduleRespositoryImpl(value: 1, values: [])) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(repository: repository)
}

/// - Tag: FR()
public func FR(repository: ScheduleRespository) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(repository: repository)
}

/// - Tag: FR()
public func FR(_ value: Int) -> FixedRatioScheduleUseCase {
    return FixedRatioScheduleUseCase(
        repository: ScheduleRespositoryImpl(value: value, values: [])
    )
}

public func VR(repository: ScheduleRespository) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(repository: repository)
}

public func VR(_ value: Int, iterations: Int = 12) -> VariableRatioScheduleUseCase {
    return VariableRatioScheduleUseCase(
        repository: ScheduleRespositoryImpl(
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
        repository: ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RR(repository: ScheduleRespository) -> RandomRatioScheduleUseCase {
    return RandomRatioScheduleUseCase(repository: repository)
}

public func RR(_ value: Int) -> RandomRatioScheduleUseCase {
    return RandomRatioScheduleUseCase(
        repository: ScheduleRespositoryImpl(
            value: value,
            values: [],
            initValue: value > 0 ? Int.random(in: 1...value) : 1
        )
    )
}

public func FI(repository: ScheduleRespository) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(repository: repository)
}

public func FI(_ value: Int, unit: TimeUnit = .seconds) -> FixedIntervalScheduleUseCase {
    return FixedIntervalScheduleUseCase(
        repository: ScheduleRespositoryImpl(value: unit.milliseconds(value), values: [])
    )
}

public func VI(repository: ScheduleRespository) -> VariableIntervalScheduleUseCase {
    return VariableIntervalScheduleUseCase(repository: repository)
}

public func VI(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableIntervalScheduleUseCase {
    let value = unit.milliseconds(value)
    return VariableIntervalScheduleUseCase(
        repository: ScheduleRespositoryImpl(
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
        repository: ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RI(repository: ScheduleRespository) -> RandomIntervalScheduleUseCase {
    return RandomIntervalScheduleUseCase(repository: repository)
}

public func RI(_ value: Int, unit: TimeUnit = .seconds) -> RandomIntervalScheduleUseCase {
    let value = unit.milliseconds(value)
    return RandomIntervalScheduleUseCase(
        repository: ScheduleRespositoryImpl(
            value: value,
            values: [],
            initValue: value > 0 ? Int.random(in: 1...value) : 1
        )
    )
}

public func FT(repository: ScheduleRespository) -> FixedTimeScheduleUseCase {
    return FixedTimeScheduleUseCase(repository: repository)
}

public func FT(_ value: Int, unit: TimeUnit = .seconds) -> FixedTimeScheduleUseCase {
    return FixedTimeScheduleUseCase(
        repository: ScheduleRespositoryImpl(
            value: unit.milliseconds(value),
            values: []
        )
    )
}

public func VT(repository: ScheduleRespository) -> VariableTimeScheduleUseCase {
    return VariableTimeScheduleUseCase(repository: repository)
}

public func VT(_ value: Int, unit: TimeUnit = .seconds, iterations: Int = 12) -> VariableTimeScheduleUseCase {
    let value = unit.milliseconds(value)
    return VariableTimeScheduleUseCase(
        repository: ScheduleRespositoryImpl(
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
        repository: ScheduleRespositoryImpl(
            value: value,
            values: values
        )
    )
}

public func RT(repository: ScheduleRespository) -> RandomTimeScheduleUseCase {
    return RandomTimeScheduleUseCase(repository: repository)
}

public func RT(_ value: Int, unit: TimeUnit = .seconds) -> RandomTimeScheduleUseCase {
    let value = unit.milliseconds(value)
    return RandomTimeScheduleUseCase(
        repository: ScheduleRespositoryImpl(
            value: value,
            values: [],
            initValue: value > 0 ? Int.random(in: 1...value) : 1
        )
    )
}

public func Alt(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) -> AlternativeScheduleUseCase {
    return AlternativeScheduleUseCase(subSchedules, repository: repository)
}

public func Alt(_ subSchedules: [ScheduleUseCase], repository: ScheduleRespository = ScheduleRespositoryImpl()) -> AlternativeScheduleUseCase {
    return AlternativeScheduleUseCase(subSchedules, repository: repository)
}

public func Conc(repository: ScheduleRespository) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(repository: repository)
}

public func Conc(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(
        repository: repository,
        subSchedules: subSchedules
    )
}

public func Conc(_ sharedSchedule: Shared<ScheduleUseCase>,
                 repository: ScheduleRespository = ScheduleRespositoryImpl()) -> ConcurrentScheduleUseCase {
    return ConcurrentScheduleUseCase(
        repository: repository, sharedSchedule: sharedSchedule
    )
}
