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
    func updateValue(isNext: Bool) -> Single<Void>
    func updateValue(_ entity: ResponseEntity) -> Single<Void>
    func updateValue(_ entity: ResponseEntity, isNext: Bool) -> Single<Void>
    func updateValue(_ result: ResultEntity) -> Single<Void>
    func updateValue(_ result: ResultEntity, isNext: Bool) -> Single<Void>
    func updateValue(numOfResponses: Int) -> Single<Void>
    func updateValue(numOfResponses: Int, isNext: Bool) -> Single<Void>
    func updateValue(milliseconds: Milliseconds) -> Single<Void>
    func updateValue(milliseconds: Milliseconds, isNext: Bool) -> Single<Void>
}
