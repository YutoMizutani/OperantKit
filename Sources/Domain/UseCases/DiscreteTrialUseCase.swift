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
    public var schedule: ScheduleUseCase
    public var state: TrialState

    public init(_ schedule: ScheduleUseCase, state: TrialState = .ready) {
        self.schedule = schedule
        self.state = state
    }
}

// MARK: - ScheduleUseCase
extension DiscreteTrialUseCase: ScheduleUseCase {
    public func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        return getState()
            .flatMap { [unowned self] in
                $0 != .ready
                    ? Single.just(ResultEntity(false, entity))
                    : self.schedule.decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
                        .flatMap { a in self.updateState(.didReinforcement).map { a } }
            }
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

    public func updateValue(isNext: Bool) -> Single<Void> {
        return schedule.updateValue(isNext: isNext)
    }

    public func updateValue(_ entity: ResponseEntity) -> Single<Void> {
        return schedule.updateValue(entity)
    }

    public func updateValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return schedule.updateValue(entity, isNext: isNext)
    }

    public func updateValue(_ result: ResultEntity) -> Single<Void> {
        return schedule.updateValue(result)
    }

    public func updateValue(_ result: ResultEntity, isNext: Bool) -> Single<Void> {
        return schedule.updateValue(result, isNext: isNext)
    }

    public func updateValue(numberOfResponses: Int) -> Single<Void> {
        return schedule.updateValue(numberOfResponses: numberOfResponses)
    }

    public func updateValue(numberOfResponses: Int, isNext: Bool) -> Single<Void> {
        return schedule.updateValue(numberOfResponses: numberOfResponses, isNext: isNext)
    }

    public func updateValue(milliseconds: Milliseconds) -> Single<Void> {
        return schedule.updateValue(milliseconds: milliseconds)
    }

    public func updateValue(milliseconds: Milliseconds, isNext: Bool) -> Single<Void> {
        return schedule.updateValue(milliseconds: milliseconds, isNext: isNext)
    }
}

// MARK: - Discreteable
extension DiscreteTrialUseCase: Discreteable {

    public func getState() -> Single<TrialState> {
        return Single.create { [weak self] single in
            guard let self = self else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(self.state))

            return Disposables.create()
        }
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

            self.state = .ready
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
