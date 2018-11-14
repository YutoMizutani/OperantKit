//
//  RatChamberColor.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct RatChamberColor {
    static let shared = RatChamberColor()

    let light = Light.self

    enum Light {
        static let off = UIColor(white: 0.94, alpha: 1.0)
        static let on = UIColor(red: 1.0, green: 1.0 * 191.0 / 255.0, blue: 0.0, alpha: 1.0)
    }

    private init() {}
}

extension UIColor {
    static var ratChamber = RatChamberColor.shared
}
