//
//  Alt.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

/// Alternative schedule
///
/// - Complexity: O(n)
public typealias Alt = Alternative

/// Alternative schedule
///
/// - Complexity: O(n)
public struct Alternative: ReinforcementScheduleType {
    let schedules: [ReinforcementScheduleType]

    init(_ schedules: [ReinforcementScheduleType]) {
        self.schedules = schedules
    }

    init(_ schedules: ReinforcementScheduleType...) {
        self.init(schedules)
    }

    public func transform(_ source: Observable<Response>) -> Observable<Consequence> {
        return Observable.combineLatest(
                schedules.map { $0.transform(source) }
            )
            .map { $0.merge() }
    }
}
