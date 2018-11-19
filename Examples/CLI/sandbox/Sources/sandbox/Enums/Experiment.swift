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

    static func availables() -> String {
        let prefix = """
        +--------+-------------------+
        |   Available experiments    |
        +--------+-------------------+
        | Number | Experiment Title  |
        +--------+-------------------+\n
        """

        var content = ""
        Experiment.allCases.forEach {
            content += """
            | \($0.rawValue)\(String(repeating: " ", count: 6 - "\($0.rawValue)".count)) | \($0.shortName)\(String(repeating: " ", count: 16 - "\($0.shortName)".count))  |\n
            """
        }

        let suffix = """
        |        |                   |
        | 0      | cancel            |
        +--------+-------------------+
        """

        return prefix + content + suffix
    }
}
