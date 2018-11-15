//
//  IntervalTimer+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/15.
//

import RxCocoa
import RxSwift

public extension Reactive where Base: IntervalTimer {

    /// Reactive wrapper for `delegate`.
    ///
    /// For more information take a look at `DelegateProxyType` protocol documentation.
    var delegate: DelegateProxy<IntervalTimer, IntervalTimerDelegate> {
        return RxIntervalTimerDelegateProxy.proxy(for: base)
    }

    /// Reactive wrapper for `milliseconds` message.
    var milliseconds: Observable<Int> {
        return delegate
            .methodInvoked(#selector(IntervalTimerDelegate.intervalTimerDidChangeMilliseconds(_:millisecods:)))
            .map { _ in
                return self.base.milliseconds
            }
    }
}
