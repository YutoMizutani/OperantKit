//
//  RatChamberLightView.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class RatChamberLightView: UIView {
    @IBOutlet private weak var bulbView: UIView!

    override var backgroundColor: UIColor? {
        set(color) {
            bulbView.backgroundColor = color
        }
        get {
            return bulbView.backgroundColor
        }
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        bulbView.backgroundColor = bulbView.backgroundColor ?? UIColor.ratChamber.light.off
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        bulbView.layer.cornerRadius = bulbView.bounds.width / 2
    }
}
