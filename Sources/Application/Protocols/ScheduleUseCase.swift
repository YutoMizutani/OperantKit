//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

/// - Tag: ScheduleUseCase
public protocol ScheduleUseCase {
    var repository: ScheduleRespository { get }
    var scheduleType: ScheduleType { get }

    /// Decision the reinforcement schedule
    func decision(_ entity: ResponseEntity) -> Single<ResultEntity>
    func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity>
    func updateValue(_ result: ResultEntity) -> Single<ResultEntity>
}

public extension ScheduleUseCase {
    func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    func updateValue(_ result: ResultEntity) -> Single<ResultEntity> {
        switch scheduleType {
        case let s where s.hasVariableSchedule():
            return Single.zip(
                self.repository.clearExtendProperty(),
                self.repository.updateLastReinforcementProperty(result.entity),
                self.repository.nextValue({
                    $1.currentOrder += 1
                    $1.currentValue = $0.values[$1.currentOrder % $0.values.count]
                    return $1
                })
            )
            .map { _ in result }
        case let s where s.hasRandomSchedule():
            return Single.zip(
                    self.repository.clearExtendProperty(),
                    self.repository.updateLastReinforcementProperty(result.entity),
                    self.repository.nextValue({
                        $1.currentValue = $0.value > 0 ? Int.random(in: 1...$0.value) : 1
                        return $1
                    })
                )
                .map { _ in result }
        default:
            return Single.zip(
                    self.repository.clearExtendProperty(),
                    self.repository.updateLastReinforcementProperty(result.entity)
                )
                .map { _ in result }
        }
    }
}
