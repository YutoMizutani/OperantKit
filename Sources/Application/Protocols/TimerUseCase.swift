//
//  TimerUseCase.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import RxSwift

public protocol TimerUseCase {
    /// Timer priority
    var priority: Priority { get set }
    /// Observable elapsed milliseconds time
    var milliseconds: PublishSubject<Milliseconds> { get }
    /// Start timer
    func start() -> Single<Void>
    /// Get elapsed time
    func elapsed() -> Single<Int>
    /// Callback delay time
    func delay(_ value: Int, currentTime: Int) -> Single<Int>
    /// Pause timer
    func pause() -> Single<Int>
    /// Resume timer
    func resume() -> Single<Int>
    /// Finish timer
    func finish() -> Single<Int>
}
