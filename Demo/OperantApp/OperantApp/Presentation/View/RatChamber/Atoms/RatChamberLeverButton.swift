//
//  RatChamberLeverButton.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class RatChamberLeverButton: UIButton {
    var insets: UIEdgeInsets?

    override func draw(_ rect: CGRect) {
        super.draw(rect)

        // Disabled image will set to normal state because could not receive any responses if disabled
        self.setImage(UIImage(named: "RatChamberLeverDisabled"), for: .normal)
        self.setImage(UIImage(named: "RatChamberLeverDisabled"), for: .disabled)
        self.setImage(nil, for: .highlighted)
        self.setImage(UIImage(named: "RatChamberLeverEnabled"), for: .selected)
        self.setImage(UIImage(named: "RatChamberLeverHighlighted"), for: [.selected, .highlighted])

        // Expand tap area
        if insets == nil {
            let minimumSizeHIG: CGFloat = 44
            let expandWidth = rect.width < minimumSizeHIG ? (minimumSizeHIG - rect.width) / 2 : 0
            let expandHeight = rect.height < minimumSizeHIG ? (minimumSizeHIG - rect.height) / 2 : 0
            self.insets = UIEdgeInsets(top: expandHeight, left: expandWidth, bottom: expandHeight, right: expandWidth)
        }
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard let insets = insets else {
            return super.point(inside: point, with: event)
        }

        var rect = bounds
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom
        return rect.contains(point)
    }
}
