//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct AlternativeScheduleUseCase {
    private var _dataStore = FixedResponseDataStore(value: 0)
    public var subSchedules: Matrix<ScheduleUseCase>

    public init(subSchedules: ScheduleUseCase...) {
        self.subSchedules = Matrix(subSchedules)!
    }

    public init(subSchedules: Matrix<ScheduleUseCase>) {
        self.subSchedules = subSchedules
    }
}

extension AlternativeScheduleUseCase {
    public var scheduleType: ScheduleType {
        return ScheduleType(
            rawValue: UInt64.max,
            shortName: "Alt(\(subSchedules.elements.map { $0.scheduleType.shortName }.joined(separator: ", ")))",
            longName: "Alternative(\(subSchedules.elements.map { $0.scheduleType.longName }.joined(separator: ", ")))"
        )
    }

//    public var dataStore: ExperimentDataStore {
//        set {
//            _dataStore.extendEntity = dataStore.extendEntity
//            _dataStore.lastReinforcementEntity = dataStore.lastReinforcementEntity
//        }
//        get {
//            return _dataStore
//        }
//    }

//    public func decision(_ observer: Observable<ResponseEntity>, isAfterEffects: Bool = true) -> Observable<ReinforcementResult> {
////        let deicion = subSchedules.elements.map { $0.decision(observer, isAfterEffects: false) }
////        return !isAfterEffects ? decision : decision
//    }
}
