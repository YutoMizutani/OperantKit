//
//  IntervalTimerDelegate.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/15.
//

import Foundation

@objc
public protocol IntervalTimerDelegate: AnyObject {
    @objc
    func intervalTimerDidChangeMilliseconds(_ intervalTimer: IntervalTimer, millisecods: Int)
}
