//
//  UIControl+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/29.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIControl {
    /// Bindable sink for `isSelected` property.
    var isSelected: Binder<Bool> {
        return Binder(self.base) { view, selected in
            view.isSelected = selected
        }
    }

    /// Bindable sink for `isHighlighted` property.
    var isHighlighted: Binder<Bool> {
        return Binder(self.base) { view, highlighted in
            view.isHighlighted = highlighted
        }
    }
}
