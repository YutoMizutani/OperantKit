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

struct RatChamberBuilder {
    func build() -> UIViewController? {
        let storyboardID = "RatChamberViewController"
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID) as? RatChamberViewController

        viewController?.inject(
            presenter: SessionPresenter(
                timer: IntervalTimer(),
                experiment: FixedRatioExperiment(
                    schedule: FixedRatioSchedule(),
                    parameter: FixedRatioParameter(value: 5),
                    state: FixedRatioState()
                )
            )
        )

        return viewController
    }
}
