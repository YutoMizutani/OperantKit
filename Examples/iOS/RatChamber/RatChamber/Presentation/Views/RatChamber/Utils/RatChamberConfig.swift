//
//  RatChamberConfig.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/11/06.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct RatChamberConfig {
    typealias LightColor = (on: UIColor, off: UIColor)

    var lightColor: (left: LightColor, center: LightColor, right: LightColor)
    var leverEnabled: (left: Bool, right: Bool)

    init(lightColor: (left: LightColor?, center: LightColor?, right: LightColor?)? = nil, leverEnabled: (left: Bool, right: Bool)? = nil) {
        let left = (UIColor.ratChamber.light.on, UIColor.ratChamber.light.off)
        let center = (UIColor.ratChamber.light.on, UIColor.ratChamber.light.off)
        let right = (UIColor.ratChamber.light.on, UIColor.ratChamber.light.off)
        let lever = (true, true)

        self.lightColor = (
            lightColor?.left ?? left,
            lightColor?.center ?? center,
            lightColor?.right ?? right
        )

        self.leverEnabled = leverEnabled ?? lever
    }
}
