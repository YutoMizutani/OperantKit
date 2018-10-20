//
//  FixedState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Fixed state
public protocol FixedState {}

// MARK: - Fixed states

extension FixedRatioState: FixedState {}
extension FixedIntervalState: FixedState {}
extension FixedTimeState: FixedState {}
