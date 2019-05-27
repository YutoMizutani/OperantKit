//
//  RatChamberPelletButton.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/11/05.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

class RatChamberPelletButton: UIButton {

    static func create(_ viewController: UIViewController, base: UIView, completion: ((RatChamberPelletButton) -> Void)?) {
        viewController.view.subviews.filter { $0 as? RatChamberPelletButton != nil }.forEach {
            $0.removeFromSuperview()
        }

        guard let button = UINib(nibName: "RatChamberPelletButton", bundle: nil)
            .instantiate(withOwner: self, options: nil)[0] as? RatChamberPelletButton
        else { return }

        button.isHidden = true
        viewController.view.addSubview(button)

        button.frame = CGRect(
            x: 0,
            y: 0,
            width: base.short / 5.5,
            height: base.short / 5.5 / 2462 * 1751
        )

        completion?(button)
    }

    func animation(base: UIView) {
        DispatchQueue.main.async {

            self.center = CGPoint(x: base.frame.minX + base.bounds.width / 2, y: base.frame.minY + base.bounds.height / 10 * 7)

            UIView.animate(withDuration: 0.01,
                           delay: 0.49,
                           options: [.allowUserInteraction, .curveEaseIn],
                           animations: {

                            self.isHidden = false

            }, completion: { _ in

                UIView.animate(withDuration: 0.2,
                               delay: 0,
                               options: [.allowUserInteraction, .curveEaseIn],
                               animations: {

                                self.center.x -= self.bounds.width / 2
                                self.center.y += self.bounds.height / 2

                }, completion: { _ in

                    UIView.animate(withDuration: 1.0,
                                   delay: 0,
                                   options: [.curveEaseIn, .allowUserInteraction],
                                   animations: {

                                    self.center.x -= (base.superview ?? base).bounds.width / 2
                                    self.center.y -= base.bounds.height / 3

                    }, completion: { _ in

                        self.isHidden = true

                    })
                })
            })
        }
    }
}
