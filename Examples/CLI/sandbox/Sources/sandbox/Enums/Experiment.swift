//
//  Experiment.swift
//  CLI
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import OperantKit

enum Experiment: Int, CaseIterable {
    case fixedRatio = 1
    case fixedInterval
    case fixedTime
}

extension Experiment {
    func run() {
        switch self {
        case .fixedRatio:
            ExperimentFR.run()
        case .fixedInterval:
            ExperimentFI.run()
        case .fixedTime:
            ExperimentFT.run()
        }
    }

    private var scheduleType: ScheduleType {
        switch self {
        case .fixedRatio:
            return .fixedRatio
        case .fixedInterval:
            return .fixedInterval
        case .fixedTime:
            return .fixedTime
        }
    }

    var shortName: String {
        return self.scheduleType.shortName
    }

    var longName: String {
        return self.scheduleType.longName
    }
}
