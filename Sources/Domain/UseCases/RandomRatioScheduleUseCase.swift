//
//  RandomRatioScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/04.
//

import RxSwift

public struct RandomRatioScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .randomRatio
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool = true) -> Observable<ResultEntity> {
        let bool = observer.flatMap { observer -> Observable<(ResponseEntity)> in
            return Observable.combineLatest(
                self.repository.getExtendProperty().asObservable(),
                self.repository.getLastReinforcementProperty().asObservable()
            )
            .map { (observer - $0.0 - $0.1) }
        }
        .RR(repository.getValue())

        let result = Observable.zip(bool, observer).map { ResultEntity($0.0, $0.1) }

        return !isUpdateIfReinforcement ? result : result
            .flatMap { observer -> Observable<ResultEntity> in
                guard observer.isReinforcement else { return Observable.just(observer) }
                return self.updateValue(result)
            }
    }
}
