//
//  RatChamberTheme.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

struct RatChamberTheme {
    static let shared = RatChamberTheme()

    let light = Light.shared

    struct Light {
        static let shared = Light()

        var off = UIColor(white: 0.94, alpha: 1.0)
        var on = UIColor(red: 1.0, green: 1.0 * 191.0 / 255.0, blue: 0.0, alpha: 1.0)

        private init() {}
    }

    private init() {}
}

extension UIColor {
    static var ratChamber = RatChamberTheme.shared
}
