//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct AlternativeScheduleUseCase: ScheduleUseCase {
    public weak var repository: ScheduleRespository?
    public var subSchedules: [ScheduleUseCase]

    public var scheduleType: ScheduleType {
        return ScheduleType(
            rawValue: UInt64.max,
            shortName: "Alt(\(subSchedules.map { $0.scheduleType.shortName }.joined(separator: ", ")))",
            longName: "Alternative(\(subSchedules.map { $0.scheduleType.longName }.joined(separator: ", ")))"
        )
    }

    public init(repository: ScheduleRespository, subSchedules: ScheduleUseCase...) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public init(repository: ScheduleRespository, subSchedules: [ScheduleUseCase]) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        let observables: [Observable<ResultEntity>] = subSchedules.map { $0.decision(observer, isUpdateIfReinforcement: false) }

        let result = observer.flatMap { observer in
            return Observable.combineLatest(observables)
                .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, observer) }
        }

        return !isUpdateIfReinforcement ? result : result
            .flatMap { observer -> Observable<ResultEntity> in
                guard observer.isReinforcement else { return Observable.just(observer) }
                return self.updateValue(result)
            }
    }

    public func updateValue(_ observer: Observable<ResultEntity>) -> Observable<ResultEntity> {
        let observables: [Observable<ResultEntity>] = subSchedules.map { $0.updateValue(observer) }

        return observer
            .flatMap { observer -> Observable<ResultEntity> in
                guard let repository = self.repository else { return Observable<ResultEntity>.error(RxError.noElements) }
                return Observable.combineLatest(
                    repository.clearExtendProperty().asObservable(),
                    repository.updateLastReinforcementProperty(observer.entity).asObservable(),
                    Observable.combineLatest(observables)
                )
                .map { _ in observer }
            }
    }
}
