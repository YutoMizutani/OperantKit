//
//  ObservableMilliseconds+.swift
//  OperantKit macOS
//
//  Created by Yuto Mizutani on 2018/11/21.
//

import RxSwift

public extension Observable where Element == Milliseconds {
    /// Delay timer with entities
    func delay(_ timer: TimerUseCase, time: @escaping () -> Int, entities: ResponseEntity...) -> Observable<Element> {
        return delay(timer, time: time, entities: entities)
    }

    /// Delay timer with entities
    func delay(_ timer: TimerUseCase, time: @escaping () -> Int, entities: [ResponseEntity] = []) -> Observable<Element> {
        return extend(time: time, entities: entities)
            .flatMap { timer.delay(time(), currentTime: $0) }
    }
}
