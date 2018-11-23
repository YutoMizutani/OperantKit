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
                recorder: ScheduleRecordable & ExperimentRecordable) {
        self.parameter = parameter
        self.recorder = recorder
    }

    public init(dataStore: ScheduleParameterable & ScheduleRecordable & ExperimentRecordable) {
        self.parameter = dataStore
        self.recorder = dataStore
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

    public func nextValue(_ schedule: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Single<()> {
        return Single.create { [weak self] single in
            guard
                let parameter = self?.parameter,
                let recorder = self?.recorder
            else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            let scheduleRecorder = schedule(parameter, recorder)
            recorder.currentOrder = scheduleRecorder.currentOrder
            recorder.currentValue = scheduleRecorder.currentValue
            single(.success(()))

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

    public func clearExtendProperty() -> Single<()> {
        return Single.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.extendEntity = ResponseEntity()
            single(.success(()))

            return Disposables.create()
        }
    }

    public func updateLastReinforcementProperty(_ entity: ResponseEntity) -> Single<()> {
        return Single.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.lastReinforcementEntity = entity
            single(.success(()))

            return Disposables.create()
        }
    }
}
