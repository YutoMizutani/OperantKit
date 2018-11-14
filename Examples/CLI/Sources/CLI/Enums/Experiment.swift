//
//  Experiment.swift
//  CLI
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import Foundation

enum Experiment: Int, CaseIterable {
    case fixedRatio = 1
}

extension Experiment {
    var shortName: String {
        switch self {
        case .fixedRatio:
            return "FR"
        }
    }

    var longName: String {
        switch self {
        case .fixedRatio:
            return "Fixed Ratio"
        }
    }

    func run() {
        switch self {
        case .fixedRatio:
            ExperimentFR.run()
        }
    }
}
