//
//  InputHelper.swift
//  sandbox
//
//  Created by Yuto Mizutani on 2018/11/14.
//

import OperantKit

struct InputHelper {
    static func value() -> Int? {
        print("Value: ", terminator: "")
        return Int(readLine() ?? "")
    }

    static func unit() -> TimeUnit? {
        print("Unit [", terminator: "")
        TimeUnit.allCases.enumerated().forEach {
            print("\($0.offset + 1). \($0.element.longName)",
                  terminator: $0.element.shortName != TimeUnit.allCases.last?.shortName ? ", " : "")
        }
        print("]: ", terminator: "")
        guard let unitNum = Int(readLine() ?? "") else { return nil }
        return TimeUnit.allCases.enumerated().first(where: { $0.offset + 1 == unitNum })?.element
    }
}
