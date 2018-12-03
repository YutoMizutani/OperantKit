//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

/// - Tag: ScheduleUseCase
public protocol ScheduleUseCase: class {
    // MARK: - Decision
    /// Decision the reinforcement schedule
    func decision(_ entity: ResponseEntity) -> Single<ResultEntity>
    func decision(_ entity: ResponseEntity, isUpdateIfReinforcement: Bool) -> Single<ResultEntity>

    // MARK: - Add
    func addExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void>

    // MARK: - Update
    func updateExtendsValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void>
    func updateValue() -> Single<Void>
    func updateValue(_ result: ResultEntity) -> Single<Void>
    func updateValue(_ milliseconds: Milliseconds) -> Single<Void>
}
