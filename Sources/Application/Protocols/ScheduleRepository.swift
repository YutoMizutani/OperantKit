//
//  ScheduleRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public protocol ScheduleRespository {
    var parameter: ScheduleParameterable { get set }
    var recorder: ScheduleRecordable { get set }
    var logger: Loggable { get set }

    // MARK: - Get
    func getValue(_ index: Int) -> Single<Int>
    func getParameter(_ index: Int) -> Single<Parameter>
    func getMaxEntity(_ index: Int) -> Single<ResponseEntity>
    func getLastReinforcement(_ index: Int) -> Single<ResponseEntity>
    func getExtendEntity(_ index: Int) -> Single<ResponseEntity>

    // MARK: - Update
    func updateMaxEntity(_ entity: ResponseEntity, index: Int) -> Single<Void>
    func updateEmaxEntity(_ entity: ResponseEntity, index: Int) -> Single<Void>
    func updateLastReinforcement(_ index: Int) -> Single<Void>
    func updateLastReinforcement(_ entity: ResponseEntity, index: Int) -> Single<Void>
    func updateLastReinforcement(numOfResponses: Int, index: Int) -> Single<Void>
    func updateLastReinforcement(milliseconds: Milliseconds, index: Int) -> Single<Void>
    func updateExtendEntity(_ entity: ResponseEntity, index: Int) -> Single<Void>

    // MARK: - Add
    func addExtendEntity(_ entity: ResponseEntity, index: Int) -> Single<Void>

    // MARK: - Next
    func nextValue(_ index: Int) -> Single<Void>

    // MARK: - Reset
    func resetExtendEntity(_ index: Int) -> Single<Void>
}

public extension ScheduleRespository {
    // MARK: - Get (extension)
    func getValue(_ index: Int = 0) -> Single<Int> {
        return Single.create { single in
            guard self.parameter.parameters.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            single(.success(self.parameter.parameters[index].getValue()))

            return Disposables.create()
        }
    }

    func getParameter(_ index: Int = 0) -> Single<Parameter> {
        return Single.create { single in
            guard self.parameter.parameters.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            single(.success(self.parameter.parameters[index]))

            return Disposables.create()
        }
    }

    func getMaxEntity(_ index: Int = 0) -> Single<ResponseEntity> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            single(.success(self.recorder.scheduleRecordEntities[index].max))

            return Disposables.create()
        }
    }

    func getLastReinforcement(_ index: Int = 0) -> Single<ResponseEntity> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            single(.success(self.recorder.scheduleRecordEntities[index].lastReinforcement))

            return Disposables.create()
        }
    }

    func getExtendEntity(_ index: Int = 0) -> Single<ResponseEntity> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            single(.success(self.recorder.scheduleRecordEntities[index].extendEntity))

            return Disposables.create()
        }
    }

    // MARK: - Update (extension)
    func updateMaxEntity(_ entity: ResponseEntity, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].max = entity
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateEmaxEntity(_ entity: ResponseEntity, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].max = self.recorder.scheduleRecordEntities[index].max.emax(entity)
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateLastReinforcement(_ index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].lastReinforcement = self.recorder.scheduleRecordEntities[index].max
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateLastReinforcement(_ entity: ResponseEntity, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].lastReinforcement = entity
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateLastReinforcement(numOfResponses: Int, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].lastReinforcement.numOfResponses = numOfResponses
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateLastReinforcement(milliseconds: Milliseconds, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].lastReinforcement.milliseconds = milliseconds
            single(.success(()))

            return Disposables.create()
        }
    }

    func updateExtendEntity(_ entity: ResponseEntity, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].extendEntity = entity
            single(.success(()))

            return Disposables.create()
        }
    }

    func addExtendEntity(_ entity: ResponseEntity, index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.recorder.scheduleRecordEntities[index].extendEntity += entity
            single(.success(()))

            return Disposables.create()
        }
    }

    // MARK: - Next (extension)
    func nextValue(_ index: Int = 0) -> Single<Void> {
        return Single.create { single in
            guard self.recorder.scheduleRecordEntities.count > index else {
                single(.error(RxError.argumentOutOfRange))
                return Disposables.create()
            }

            self.parameter.parameters[index].next()
            single(.success(()))

            return Disposables.create()
        }
    }

    // MARK: - Reset (extension)
    func resetExtendEntity(_ index: Int = 0) -> Single<Void> {
        return Single.create { single in

            self.recorder.scheduleRecordEntities[index].extendEntity = ResponseEntity.zero
            single(.success(()))

            return Disposables.create()
        }
    }
}
