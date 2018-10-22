//
//  RatChamberBuilder.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxCocoa
import UIKit

extension IntervalTimer {
    convenience init() {
    }
}

extension FixedRatioExperiment {
    init(schedule: FixedRatioSchedule, parameter: FixedRatioParameter, state: FixedRatioState) {
        self.schedule = schedule
        self.parameter = parameter
        self.state = state
    }
}

extension FixedRatioSchedule {
    init() {}
}
extension FixedRatioParameter {
    init(value: Int) {
        self.value = value
    }
}
extension FixedRatioState {
    init() {
        self.numOfResponse = BehaviorRelay<Int>(value: 0)
    }
}

struct RatChamberBuilder {
    func build() -> UIViewController? {
        let storyboardID = "RatChamberView"
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? RatChamberView

        viewController?.inject(
            presenter: SessionPresenter(
                timer: IntervalTimer.new(),
                experiment: FixedRatioExperiment(
                    schedule: FixedRatioSchedule(),
                    parameter: FixedRatioParameter(value: 5),
                    state: FixedRatioState()
                )
            )
        )
        viewController?.title = "foo"

        print(viewController?.title)
        return viewController
    }
}
