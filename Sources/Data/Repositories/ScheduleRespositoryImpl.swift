//
//  ScheduleRespositoryImpl.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public class ScheduleRespositoryImpl: ScheduleRespository {
    private weak var parameter: ScheduleParameterable?
    private weak var recorder: (ScheduleRecordable & ExperimentRecordable)?

    public init(parameter: ScheduleParameterable,
                recorder: (ScheduleRecordable & ExperimentRecordable)) {
        self.parameter = parameter
        self.recorder = recorder
    }

    public func getValue() -> Single<Int> {
        return Single<Int>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.currentValue))

            return Disposables.create()
        }
    }

    public func nextValue(_ schedule: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Completable {
        return Completable.create { [weak self] completable in
            guard
                let parameter = self?.parameter,
                let recorder = self?.recorder
            else {
                completable(.error(RxError.noElements))
                return Disposables.create()
            }

            let scheduleRecorder = schedule(parameter, recorder)
            recorder.currentOrder = scheduleRecorder.currentOrder
            recorder.currentValue = scheduleRecorder.currentValue
            completable(.completed)

            return Disposables.create()
        }
    }

    public func getExtendProperty() -> Single<ResponseEntity> {
        return Single<ResponseEntity>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.extendEntity))

            return Disposables.create()
        }
    }

    public func getLastReinforcementProperty() -> Single<ResponseEntity> {
        return Single<ResponseEntity>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.lastReinforcementEntity))

            return Disposables.create()
        }
    }

    public func clearExtendProperty() -> Completable {
        return Completable.create { [weak self] completable in
            guard let recorder = self?.recorder else {
                    completable(.error(RxError.noElements))
                    return Disposables.create()
            }

            recorder.extendEntity = ResponseEntity()
            completable(.completed)

            return Disposables.create()
        }
    }

    public func updateLastReinforcementProperty(_ entity: ResponseEntity) -> Completable {
        return Completable.create { [weak self] completable in
            guard let recorder = self?.recorder else {
                completable(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.lastReinforcementEntity = entity
            completable(.completed)

            return Disposables.create()
        }
    }

}
