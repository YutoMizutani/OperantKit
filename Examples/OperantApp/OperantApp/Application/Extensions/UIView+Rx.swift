//
//  UIView+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/27.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIView {
    /// Bindable sink for `backgroundColor` property.
    var backgroundColor: Binder<UIColor> {
        return Binder(self.base) { view, color in
            view.backgroundColor = color
        }
    }
}
