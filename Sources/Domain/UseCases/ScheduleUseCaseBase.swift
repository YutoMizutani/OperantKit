//
//  ScheduleUseCaseBase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/12/03.
//

import RxSwift

public protocol ScheduleUseCaseInterfaceAdapter: class {
    var repository: ScheduleRespository { get }
}

public class ScheduleUseCaseBase: ScheduleUseCaseInterfaceAdapter {
    public var repository: ScheduleRespository

    public init(_ repository: ScheduleRespository) {
        self.repository = repository
    }
}

public extension ScheduleUseCaseBase {
    func getCurrentValue(_ entity: ResponseEntity) -> Single<ResponseEntity> {
        return Single.zip(
            repository.updateEmaxEntity(entity),
            repository.getExtendEntity(),
            repository.getLastReinforcement()
            )
            .map { (entity - $0.1 - $0.2) }
    }
}

public extension ScheduleUseCase where Self: ScheduleUseCaseBase {

    func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    func addExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(
            repository.addExtendEntity(entity),
            isNext ? repository.nextValue() : Single.just(())
            )
            .mapToVoid()
    }

    func updateExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(
            repository.updateExtendEntity(entity),
            isNext ? repository.nextValue() : Single.just(())
            )
            .mapToVoid()
    }

    func updateValue() -> Single<Void> {
        return Single.zip(
            repository.resetExtendEntity(),
            repository.updateLastReinforcement(),
            repository.nextValue()
            )
            .mapToVoid()
    }

    func updateValue(_ result: ResultEntity) -> Single<Void> {
        return Single.zip(
            repository.resetExtendEntity(),
            repository.updateLastReinforcement(result.entity),
            repository.nextValue()
            )
            .mapToVoid()
    }

    func updateValue(_ milliseconds: Milliseconds) -> Single<Void> {
        return Single.zip(
            repository.resetExtendEntity(),
            repository.updateLastReinforcement(milliseconds),
            repository.nextValue()
            )
            .mapToVoid()
    }

    func updateValueIfReinforcement(_ result: Single<ResultEntity>) -> Single<ResultEntity> {
        return result
            .flatMap { [weak self] r in
                guard let self = self, r.isReinforcement else { return result }
                return self.updateValue(r).map { _ in r }
            }
    }
}
