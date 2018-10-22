//
//  RxSwift+.swift
//  OperantKit iOS
//
//  Created by Yuto Mizutani on 2018/10/22.
//

import RxSwift

public extension Observable {
    func interval(_ timer: IntervalTimer) -> Observable<Int> {
        return map { _ in timer.elapsed.milliseconds.now.value }
    }
}
