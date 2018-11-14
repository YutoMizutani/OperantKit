//
//  MainBuilder.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/19.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct MainBuilder {
}

extension MainBuilder {
    func build() -> UIViewController {
        let storyboardID = "ViewController"
        let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: storyboardID)
        return viewController
    }
}
