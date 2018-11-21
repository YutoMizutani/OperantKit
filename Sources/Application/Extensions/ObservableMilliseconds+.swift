//
//  ObservableMilliseconds+.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2018/11/21.
//

import RxSwift

public extension Observable where E == Milliseconds {
    /// Delay timer with entities
    func delay(_ timer: TimerUseCase, time: @escaping () -> Int, entities: ResponseEntity...) -> Observable<E> {
        return delay(timer, time: time, entities: entities)
    }

    /// Delay timer with entities
    func delay(_ timer: TimerUseCase, time: @escaping () -> Int, entities: [ResponseEntity] = []) -> Observable<E> {
        return self
            .extend(time: time, entities: entities)
            .flatMap { timer.delay(time(), currentTime: $0) }
    }
}
