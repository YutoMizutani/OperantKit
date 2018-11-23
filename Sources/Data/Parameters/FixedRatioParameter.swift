//
//  FixedRatioParameter.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/23.
//

import Foundation

public class FixedRatioParameter: ScheduleParameterable {
    public var value: Int
    public var values: [Int] = []

    public init(_ value: Int) {
        self.value = value
    }
}
