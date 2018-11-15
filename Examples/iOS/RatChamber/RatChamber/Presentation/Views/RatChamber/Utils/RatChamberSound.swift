//
//  RatChamberSound.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import AVFoundation
import UIKit

struct RatChamberSound {
    static let shared = RatChamberSound()

    let lever = Lever.shared
    let feeder = Feeder.shared

    struct Lever {
        fileprivate static let shared = Lever()

        var push = NSDataAsset(name: "RatChamberLeverPushSound")?.data.player(type: "wav")
        var pull = NSDataAsset(name: "RatChamberLeverPullSound")?.data.player(type: "wav")

        private init() {}
    }

    struct Feeder {
        fileprivate static let shared = Feeder()

        var operatingSound = NSDataAsset(name: "RatChamberFeederSound")?.data.player(type: "wav")

        private init() {}
    }

    private init() {}
}

extension AVAudioPlayer {
    static var ratChamber = RatChamberSound.shared
}
