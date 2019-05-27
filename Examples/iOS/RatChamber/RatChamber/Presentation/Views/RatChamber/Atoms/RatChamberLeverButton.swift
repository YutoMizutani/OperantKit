//
//  RatChamberLeverButton.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import AVFoundation
import RxCocoa
import RxSwift
import UIKit

class RatChamberLeverButton: UIButton {
    var insets: UIEdgeInsets?

    var players: (push: AVAudioPlayer?, pull: AVAudioPlayer?)? {
        didSet {
            binding()
        }
    }
    private var disposeBag = DisposeBag()

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

        // Sounds
        players = (RatChamberSound.shared.lever.pull, RatChamberSound.shared.lever.push)
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

extension RatChamberLeverButton {
    private func binding() {
        disposeBag = DisposeBag()

        // Sound
        players?.pull?.prepareToPlay()
        players?.push?.prepareToPlay()

        self.rx.touchDown
            .filter { [unowned self] in self.isSelected }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.players?.push?.currentTime = 0
                self.players?.push?.play()
            })
            .disposed(by: disposeBag)

        self.rx.touchUpInside
            .filter { [unowned self] in self.isSelected }
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                self.players?.pull?.currentTime = 0
                self.players?.pull?.play()
            })
            .disposed(by: disposeBag)
    }
}
