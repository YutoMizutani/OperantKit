//
//  DiscreteTrialUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

/// [Discreteable](x-source-tag://Discreteable) and [ScheduleUseCase](x-source-tag://ScheduleUseCase)
/// - Tag: DiscreteTrialUseCase
public class DiscreteTrialUseCase {
    public var state: TrialState = .prepare
    public var schedule: ScheduleUseCase

    public init(_ schedule: ScheduleUseCase) {
        self.schedule = schedule
    }
}

// MARK: - ScheduleUseCase
extension DiscreteTrialUseCase: ScheduleUseCase {
    public func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        guard state == .prepare else { return Single.just(ResultEntity(false, entity)) }
        return schedule.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
            .flatMap { a in self.updateState(.didReinforcement).map { a } }
    }

    public func addExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return schedule.addExtendsValue(entity, isNext: isNext)
    }

    public func updateExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return schedule.updateExtendsValue(entity, isNext: isNext)
    }

    public func updateValue() -> Single<Void> {
        return schedule.updateValue()
    }

    public func updateValue(_ result: ResultEntity) -> Single<Void> {
        return schedule.updateValue(result)
    }

    public func updateValue(_ milliseconds: Milliseconds) -> Single<Void> {
        return schedule.updateValue(milliseconds)
    }
}

// MARK: - Discreteable
extension DiscreteTrialUseCase: Discreteable {

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
        return Single.zip(
            schedule.updateExtendsValue(entity, isNext: true),
            nextTrial()
            )
            .mapToVoid()
    }
}
