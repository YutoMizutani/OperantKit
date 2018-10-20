//
//  RatioState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import RxCocoa

/// Ratio state
public protocol RatioState {
    var numOfResponse: BehaviorRelay<Int> { get set }
}

// MARK: - Ratio states

extension FixedRatioState: RatioState {}
extension VariableRatioState: RatioState {}
extension RandomRatioState: RatioState {}
