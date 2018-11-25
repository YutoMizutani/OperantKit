//
//  DiscreteTrialUseCaseImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public struct DiscreteTrialUseCaseImpl: ScheduleUseCase {
    public var discreteTrialRepository: DiscreteTrialRepository
    public var repository: ScheduleRespository {
        return schedule.repository
    }
    public var schedule: ScheduleUseCase
    public var scheduleType: ScheduleType {
        return schedule.scheduleType
    }

    public init(_ schedule: ScheduleUseCase, maxTrials: Int) {
        self.schedule = schedule
        self.discreteTrialRepository = DiscreteTrialRepositoryImpl(dataStore: DiscreteTrialDataStoreImpl(maxTrials: maxTrials))
    }

    public init(_ schedule: ScheduleUseCase, repository: DiscreteTrialRepository) {
        self.schedule = schedule
        self.discreteTrialRepository = repository
    }

    public func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity> {
        return schedule.decision(observer, isUpdateIfReinforcement: isUpdateIfReinforcement)
            .map {
                ResultEntity(
                    $0.isReinforcement && self.discreteTrialRepository.getTrialState() == .prepare,
                    $0.entity
                )
            }
    }
}
