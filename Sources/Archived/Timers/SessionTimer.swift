//
//  SessionTimer.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import RxSwift

public protocol SessionTimer {
    /// Timer priority
    var priority: Priority { get set }
    /// Observable elapsed all time
    var realTime: Observable<RealTime> { get }
    /// Observable elapsed session time
    var sessionTime: Observable<SessionTime> { get }
    /// Start timer
    func start() -> Single<Void>
    /// Get elapsed time
    func elapsed() -> Single<SessionTime>
    /// Stop timer and callback real time
    func delay(_ value: Milliseconds, currentTime: SessionTime) -> Single<RealTime>
    /// Pause timer
    func pause() -> Single<RealTime>
    /// Resume timer
    func resume() -> Single<RealTime>
    /// Finish timer
    func finish() -> Single<RealTime>
}
