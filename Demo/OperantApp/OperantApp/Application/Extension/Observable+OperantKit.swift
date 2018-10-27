//
//  Observable+OperantKit.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxSwift

public extension Observable {
    func interval(_ timer: IntervalTimer) -> Observable<Int> {
        return map { _ in timer.elapsed.milliseconds.value }
    }
}

public extension Observable where E == Int {
    func getResponse(_ timer: IntervalTimer) -> Observable<ResponseDetail> {
        return map { ($0, timer.elapsed.milliseconds.value) }
    }
}
