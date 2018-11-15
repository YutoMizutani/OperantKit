//
//  IntervalTimer+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/15.
//

import RxCocoa
import RxSwift

extension IntervalTimer: ReactiveCompatible {}

public extension Reactive where Base: IntervalTimer {
    /// Reactive wrapper for `milliseconds` message.
    var milliseconds: BehaviorRelay<Int> {
        return base.rx_milliseconds
    }
}
