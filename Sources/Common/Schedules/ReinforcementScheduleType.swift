//
//  ReinforcementScheduleType.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

public protocol ReinforcementScheduleType {
    func transform(_ source: Observable<Response>) -> Observable<Consequence>
}
