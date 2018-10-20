//
//  TimeState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

/// Time state
public protocol TimeState {
    var elapsedTime: BehaviorRelay<Int> { get set }
}

// MARK: - Time states

extension FixedTimeState: TimeState {}
extension VariableTimeState: TimeState {}
extension RandomTimeState: TimeState {}
