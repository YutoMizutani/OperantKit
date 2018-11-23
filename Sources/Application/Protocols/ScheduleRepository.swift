//
//  ScheduleRepository.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/22.
//

import RxSwift

public protocol ScheduleRespository: class {
    func getValue() -> Single<Int>
    func nextValue(_: @escaping (ScheduleParameterable, ScheduleRecordable) -> ScheduleRecordable) -> Single<()>
    func getExtendProperty() -> Single<ResponseEntity>
    func getLastReinforcementProperty() -> Single<ResponseEntity>
    func clearExtendProperty() -> Single<()>
    func updateLastReinforcementProperty(_:ResponseEntity) -> Single<()>
}
