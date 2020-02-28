//
//  UIButton+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/26.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIButton {
    /// Reactive wrapper for `TouchDown` control event.
    var touchDown: ControlEvent<Void> {
        return controlEvent(.touchDown)
    }

    /// Reactive wrapper for `TouchUpInside` control event.
    var touchUpInside: ControlEvent<Void> {
        return controlEvent(.touchUpInside)
    }
}
