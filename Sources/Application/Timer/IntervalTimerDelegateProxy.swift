//
//  IntervalTimerDelegateProxy.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/15.
//

import RxCocoa
import RxSwift

extension IntervalTimer: HasDelegate {
    public typealias Delegate = IntervalTimerDelegate
}

open class RxIntervalTimerDelegateProxy
    : DelegateProxy<IntervalTimer, IntervalTimerDelegate>, DelegateProxyType {

    /// Typed parent object.
    public weak private(set) var intervalTimer: IntervalTimer?

    /// - parameter intervalTimer: Parent object for delegate proxy.
    public init(intervalTimer: ParentObject) {
        self.intervalTimer = intervalTimer
        super.init(parentObject: intervalTimer, delegateProxy: RxIntervalTimerDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxIntervalTimerDelegateProxy(intervalTimer: $0) }
    }
}
