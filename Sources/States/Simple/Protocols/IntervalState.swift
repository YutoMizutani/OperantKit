//
//  IntervalState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

/// Interval state
public protocol IntervalState {
    var responseTime: BehaviorRelay<Int> { get set }
}

// MARK: - Interval states

extension FixedIntervalState: IntervalState {}
extension VariableIntervalState: IntervalState {}
extension RandomIntervalState: IntervalState {}
