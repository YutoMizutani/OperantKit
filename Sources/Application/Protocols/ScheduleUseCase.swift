//
//  ScheduleUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/02.
//

import RxSwift

public protocol ScheduleUseCase {
    var repository: ScheduleRespository { get }
    var scheduleType: ScheduleType { get }

    /// Decision the reinforcement schedule
    func decision(_ observer: Observable<ResponseEntity>) -> Observable<ResultEntity>
    func decision(_ observer: Observable<ResponseEntity>, isUpdateIfReinforcement: Bool) -> Observable<ResultEntity>
    func updateValue(_ observer: Observable<ResultEntity>) -> Observable<ResultEntity>
}

public extension ScheduleUseCase {
    func decision(_ observer: Observable<ResponseEntity>) -> Observable<ResultEntity> {
        return decision(observer, isUpdateIfReinforcement: true)
    }

    func updateValue(_ observer: Observable<ResultEntity>) -> Observable<ResultEntity> {
        switch scheduleType {
        case let s where s.hasVariableSchedule():
            return observer
                .flatMap { observer -> Observable<ResultEntity> in
                    return Observable.zip(
                        self.repository.clearExtendProperty().asObservable(),
                        self.repository.updateLastReinforcementProperty(observer.entity).asObservable(),
                        self.repository.nextValue({
                            $1.currentOrder += 1
                            $1.currentValue = $0.values[$1.currentOrder % $0.values.count]
                            return $1
                        }).asObservable()
                    )
                    .map { _ in observer }
                }
        case let s where s.hasRandomSchedule():
            return observer
                .flatMap { observer -> Observable<ResultEntity> in
                    return Observable.zip(
                        self.repository.clearExtendProperty().asObservable(),
                        self.repository.updateLastReinforcementProperty(observer.entity).asObservable(),
                        self.repository.nextValue({
                            $1.currentValue = $0.value > 0 ? Int.random(in: 1...$0.value) : 1
                            return $1
                        }).asObservable()
                    )
                    .map { _ in observer }
                }
        default:
            return observer
                .flatMap { observer -> Observable<ResultEntity> in
                    return Observable.zip(
                        self.repository.clearExtendProperty().asObservable(),
                        self.repository.updateLastReinforcementProperty(observer.entity).asObservable()
                    )
                    .map { _ in observer }
                }
        }
    }
}
