//
//  RatioState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

public protocol RatioState {
    var numOfResponse: BehaviorRelay<Int> { get set }
}

extension FixedRatioState: RatioState {}
extension VariableRatioState: RatioState {}
extension RandomRatioState: RatioState {}
