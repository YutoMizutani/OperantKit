//
//  AlternativeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct AlternativeScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository
    public var subSchedules: [ScheduleUseCase]

    public var scheduleType: ScheduleType {
        return ScheduleType(
            rawValue: UInt64.max,
            shortName: "Alt(\(subSchedules.map { $0.scheduleType.shortName }.joined(separator: ", ")))",
            longName: "Alternative(\(subSchedules.map { $0.scheduleType.longName }.joined(separator: ", ")))"
        )
    }

    public init(_ subSchedules: ScheduleUseCase..., repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public init(_ subSchedules: [ScheduleUseCase], repository: ScheduleRespository = ScheduleRespositoryImpl()) {
        self.repository = repository
        self.subSchedules = subSchedules
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        let sharedObserver = observer.share(replay: 1)
        let observables: [Observable<ResultEntity>] = subSchedules.map { $0.decision(sharedObserver, isUpdateIfReinforcement: false) }

        let result = sharedObserver.flatMap { observer in
            return Observable.zip(observables)
                .map { ResultEntity(!$0.filter({ $0.isReinforcement }).isEmpty, observer) }
        }

        return !isUpdateIfReinforcement ? result : result
            .flatMap { observer -> Observable<ResultEntity> in
                guard observer.isReinforcement else { return Observable.just(observer) }
                return self.updateValue(result)
            }
    }

    public func updateValue(_ observer: Observable<ResultEntity>) -> Observable<ResultEntity> {
        let sharedObserver = observer.share(replay: 1)
        let observables: [Observable<ResultEntity>] = subSchedules.map { $0.updateValue(sharedObserver) }

        return sharedObserver
            .flatMap { observer -> Observable<ResultEntity> in
                return Observable.zip(
                    self.repository.clearExtendProperty().asObservable(),
                    self.repository.updateLastReinforcementProperty(observer.entity).asObservable(),
                    Observable.zip(observables)
                    )
                    .map { _ in observer }
            }
    }
}
