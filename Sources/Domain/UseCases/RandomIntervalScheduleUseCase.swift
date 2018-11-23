//
//  RandomIntervalScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public struct RandomIntervalScheduleUseCase: ScheduleUseCase {
    public weak var repository: ScheduleRespository?

    public var scheduleType: ScheduleType {
        return .randomInterval
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool = true) -> Observable<ResultEntity> {
        guard let repository = self.repository else { return Observable<ResultEntity>.error(RxError.noElements) }
        let bool = observer.flatMap { observer -> Observable<(ResponseEntity)> in
            guard let repository = self.repository else { return Observable<ResponseEntity>.error(RxError.noElements) }
            return Observable.combineLatest(
                repository.getExtendProperty().asObservable(),
                repository.getLastReinforcementProperty().asObservable()
            )
            .map { (observer - $0.0 - $0.1) }
        }
        .RI(repository.getValue())

        let result = Observable.zip(bool, observer).map { ResultEntity($0.0, $0.1) }

        return !isUpdateIfReinforcement ? result : result
            .flatMap { observer -> Observable<ResultEntity> in
                guard observer.isReinforcement else { return Observable.just(observer) }
                return self.updateValue(result)
            }
    }
}
