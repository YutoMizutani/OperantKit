//
//  TimeState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public protocol TimeState {
    var elapsedTime: BehaviorRelay<Int> { get set }
}

extension FixedTimeState: TimeState {}
extension VariableTimeState: TimeState {}
extension RandomTimeState: TimeState {}
