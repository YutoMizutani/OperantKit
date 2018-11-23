//
//  FixedTimeScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import RxSwift

public struct FixedTimeScheduleUseCase: ScheduleUseCase {
    public var repository: ScheduleRespository

    public var scheduleType: ScheduleType {
        return .randomRatio
    }

    public init(repository: ScheduleRespository) {
        self.repository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        let sharedObserver = observer.share(replay: 1)
        let bool = sharedObserver.flatMap { observer -> Observable<(ResponseEntity)> in
            return Observable.zip(
                self.repository.getExtendProperty().asObservable(),
                self.repository.getLastReinforcementProperty().asObservable()
            )
            .map { (observer - $0.0 - $0.1) }
        }
        .FT(repository.getValue())

        let result = Observable.zip(bool, sharedObserver).map { ResultEntity($0.0, $0.1) }

        return !isUpdateIfReinforcement ? result : result
            .flatMap {
                $0.isReinforcement
                    ? self.updateValue(Observable.just($0))
                    : Observable.just($0)
            }
    }
}
