//
//  DiscreteTrialUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

/// [Discreteable](x-source-tag://Discreteable) and [ScheduleUseCase](x-source-tag://ScheduleUseCase)
/// - Tag: DiscreteTrialUseCase
public class DiscreteTrialUseCase: ScheduleUseCase & Discreteable {
    public var state: TrialState = .prepare

    public var repository: ScheduleRespository {
        return schedule.repository
    }
    public var schedule: ScheduleUseCase

    public init(_ schedule: ScheduleUseCase) {
        self.schedule = schedule
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        return state == .prepare
            ? schedule.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
                .flatMap { a in self.updateState(.didReinforcement).map { a } }
            : Single.just(ResultEntity(false, entity))
    }

    public func updateState(_ state: TrialState) -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.state = state
            single(.success(()))

            return Disposables.create()
        }
    }

    public func nextTrial() -> Single<Void> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            self.state = .prepare
            single(.success(()))

            return Disposables.create()
        }
    }

    public func next(with entity: ResponseEntity) -> Single<Void> {
        return Single<Void>.zip(
            repository.resetExtendEntity(),
            repository.updateExtendEntity(entity),
            nextTrial()
        ) { _, _, _ in () }
    }
}
