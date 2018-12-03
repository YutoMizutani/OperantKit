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
        return Single.zip(subSchedules.map { $0.addExtendsValue(entity, isNext: isNext) })
            .mapToVoid()
    }

    func updateExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateExtendsValue(entity, isNext: isNext) })
            .mapToVoid()
    }

    func updateValue() -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue() })
            .mapToVoid()
    }

    func updateValue(_ result: ResultEntity) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(result) })
            .mapToVoid()
    }

    func updateValue(_ milliseconds: Milliseconds) -> Single<Void> {
        return Single.zip(subSchedules.map { $0.updateValue(milliseconds) })
            .mapToVoid()
    }

    func updateValueIfReinforcement(_ result: Single<ResultEntity>) -> Single<ResultEntity> {
        return result
            .flatMap { [weak self] r in
                guard let self = self, r.isReinforcement else { return Single.just(r) }
                return self.updateValue(r).map { r }
            }
    }
}
