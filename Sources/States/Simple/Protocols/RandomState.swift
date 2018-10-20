//
//  RandomState.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/20.
//

import Foundation

/// Random state
public protocol RandomState {}

// MARK: - Random states

extension RandomRatioState: RandomState {}
extension RandomIntervalState: RandomState {}
extension RandomTimeState: RandomState {}
