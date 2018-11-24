//
//  ScheduleRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public protocol ScheduleRespository: class {
    var parameter: ScheduleParameterable { get }
    var recorder: ScheduleRecordable & ExperimentRecordable { get }

    func getValue() -> Single<Int>
    func nextValue(_: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Single<()>
    func getExtendProperty() -> Single<ResponseEntity>
    func getLastReinforcementProperty() -> Single<ResponseEntity>
    func clearExtendProperty() -> Single<()>
    func updateExtendProperty(_: ResponseEntity) -> Single<()>
    func updateExtendProperty(_: @escaping () -> ResponseEntity) -> Single<()>
    func updateLastReinforcementProperty(_: ResponseEntity) -> Single<()>
    func updateLastReinforcementProperty(_: @escaping () -> ResponseEntity) -> Single<()>
}

public extension ScheduleRespository {
    func getValue() -> Single<Int> {
        return Single<Int>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.currentValue))

            return Disposables.create()
        }
    }

    func nextValue(_ schedule: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Single<()> {
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

    func getExtendProperty() -> Single<ResponseEntity> {
        return Single<ResponseEntity>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.extendEntity))

            return Disposables.create()
        }
    }

    func getLastReinforcementProperty() -> Single<ResponseEntity> {
        return Single<ResponseEntity>.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            single(.success(recorder.lastReinforcementEntity))

            return Disposables.create()
        }
    }

    func clearExtendProperty() -> Single<()> {
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

    func updateExtendProperty(_ entity: ResponseEntity) -> Single<()> {
        return Single.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.extendEntity = entity
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateExtendProperty(_ entity: @escaping () -> ResponseEntity) -> Single<()> {
        return Single.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.extendEntity = entity()
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateLastReinforcementProperty(_ entity: ResponseEntity) -> Single<()> {
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

    func updateLastReinforcementProperty(_ entity: @escaping () -> ResponseEntity) -> Single<()> {
        return Single.create { [weak self] single in
            guard let recorder = self?.recorder else {
                single(.error(RxError.noElements))
                return Disposables.create()
            }

            recorder.lastReinforcementEntity = entity()
            single(.success(()))

            return Disposables.create()
        }
    }
}
