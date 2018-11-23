//
//  ScheduleRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public protocol ScheduleRespository {
    func getValue() -> Single<Int>
    func nextValue(_: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Completable
    func getExtendProperty() -> Single<ResponseEntity>
    func getLastReinforcementProperty() -> Single<ResponseEntity>
    func clearExtendProperty() -> Completable
    func updateLastReinforcementProperty(_:ResponseEntity) -> Completable
}
