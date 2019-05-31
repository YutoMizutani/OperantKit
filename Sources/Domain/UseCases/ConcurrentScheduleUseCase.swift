//
//  ConcurrentScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import RxSwift

public class ConcurrentScheduleUseCase: CompoundScheduleUseCaseBase, ScheduleUseCase {
    override public var subSchedules: [ScheduleUseCase] {
        didSet {
            lastDecisionEntities = [ResponseEntity](repeating: ResponseEntity.zero, count: subSchedules.count)
        }
    }
    public var lastDecisionEntities: [ResponseEntity]
    public var isShared: Bool

    public init(_ subSchedules: [ScheduleUseCase], isShared: Bool = false) {
        self.isShared = isShared
        self.lastDecisionEntities = [ResponseEntity](repeating: ResponseEntity.zero, count: subSchedules.count)
        super.init(subSchedules)
    }

    public convenience init(_ subSchedules: ScheduleUseCase..., isShared: Bool = false) {
        self.init(subSchedules, isShared: isShared)
    }

    // MARK: - ScheduleUseCase

    public func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity> {
        guard !subSchedules.isEmpty else { return Single<ResultEntity>.error(RxError.noElements) }
        lastDecisionEntities[0] = entity
        return subSchedules[0].decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
    }

    // MARK: - Select index

    public func decision(_ entity: ResponseEntity, index: Int,
                         isUpdateIfReinforcement: Bool = true,
                         isSharedUpdate: Bool = false) -> Single<ResultEntity> {
        guard isShared || subSchedules.count > index else { return Single<ResultEntity>.error(RxError.noElements) }
        let index = isShared ? 0 : index
        lastDecisionEntities[index] = entity
        let result = subSchedules[index].decision(entity, isUpdateIfReinforcement: isUpdateIfReinforcement)
        return !(isUpdateIfReinforcement && isSharedUpdate) ? result : result
            .flatMap { [weak self] r in
                guard let self = self, r.isReinforcement else { return Single.just(r) }
                self.lastDecisionEntities = self.lastDecisionEntities.map { ResponseEntity($0.numOfResponses, r.entity.milliseconds) }
                return Single.zip(
                    self.subSchedules.enumerated()
                        .filter { $0.offset != index }
                        .map { [unowned self] in
                            $0.element.updateValue(ResultEntity(r.isReinforcement, self.lastDecisionEntities[$0.offset]))
                        }
                    )
                    .map { _ in r }
            }
    }

    public func addExtendsValue(_ entity: ResponseEntity, index: Int, isNext: Bool) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].addExtendsValue(entity, isNext: isNext)
    }

    public func updateExtendsValue(_ entity: ResponseEntity, index: Int, isNext: Bool) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateExtendsValue(entity, isNext: isNext)
    }

    public func updateValue(index: Int) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateValue()
    }

    public func updateValue(_ result: ResultEntity, index: Int) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateValue(result)
    }

    public func updateValue(numOfResponses: Int, index: Int) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateValue(numOfResponses: numOfResponses)
    }

    public func updateValue(milliseconds: Milliseconds, index: Int) -> Single<Void> {
        guard isShared || subSchedules.count > index else { return Single<Void>.error(RxError.noElements) }
        return subSchedules[isShared ? 0 : index].updateValue(milliseconds: milliseconds)
    }
}

public extension ConcurrentScheduleUseCase {
    convenience init(_ sharedSchedule: Shared<ScheduleUseCase>) {
        self.init([sharedSchedule.element], isShared: true)
    }
}
