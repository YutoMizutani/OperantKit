//
//  CompoundScheduleUseCaseBase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/12/03.
//

import RxSwift

public protocol CompoundScheduleUseCaseInterfaceAdapter: class {
    var subSchedules: [ScheduleUseCase] { get }
}

public class CompoundScheduleUseCaseBase: CompoundScheduleUseCaseInterfaceAdapter {
    public var subSchedules: [ScheduleUseCase]

    public init(_ subSchedules: [ScheduleUseCase]) {
        self.subSchedules = subSchedules
    }

    public convenience init(_ subSchedules: ScheduleUseCase...) {
        self.init(subSchedules)
    }
}

public extension ScheduleUseCase where Self: CompoundScheduleUseCaseBase {

    func decision(_ entity: ResponseEntity) -> Single<ResultEntity> {
        return decision(entity, isUpdateIfReinforcement: true)
    }

    func addExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.addExtendsValue(entity, isNext: isNext) }) { _ in }
    }

    func updateExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateExtendsValue(entity, isNext: isNext) }) { _ in }
    }

    func updateValue() -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue() }) { _ in }
    }

    func updateValue(isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(isNext: isNext) }) { _ in }
    }

    func updateValue(_ entity: ResponseEntity) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(entity) }) { _ in }
    }

    func updateValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(entity, isNext: isNext) }) { _ in }
    }

    func updateValue(_ result: ResultEntity) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(result) }) { _ in }
    }

    func updateValue(_ result: ResultEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(result, isNext: isNext) }) { _ in }
    }

    func updateValue(numOfResponses: Int) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(numOfResponses: numOfResponses) }) { _ in }
    }

    func updateValue(numOfResponses: Int, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(numOfResponses: numOfResponses, isNext: isNext) }) { _ in }
    }

    func updateValue(milliseconds: Milliseconds) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(milliseconds: milliseconds) }) { _ in }
    }

    func updateValue(milliseconds: Milliseconds, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(milliseconds: milliseconds, isNext: isNext) }) { _ in }
    }

    func updateValueIfReinforcement(_ result: Single<ResultEntity>) -> Single<ResultEntity> {
        return result
            .flatMap { [weak self] r in
                guard let self = self, r.isReinforcement else { return Single.just(r) }
                return self.updateValue(r).map { r }
            }
    }
}
