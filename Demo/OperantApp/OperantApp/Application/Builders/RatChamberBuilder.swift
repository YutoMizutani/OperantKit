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
                timerUseCase: IntervalTimerUseCase(),
                wireframe: EmptyWireframe(),
                schedule: { $0.FR(5) }
            )
        )

        return viewController
    }
}
