//
//  RatChamberView.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RatChamberView: UIView {
    @IBOutlet private weak var baseView: RatChamberBaseView!
    @IBOutlet private weak var leftLight: RatChamberLightView!
    @IBOutlet private weak var centerLight: RatChamberLightView!
    @IBOutlet private weak var rightLight: RatChamberLightView!
    @IBOutlet private weak var leftLever: RatChamberLeverButton!
    @IBOutlet private weak var rightLever: RatChamberLeverButton!
}
