//
//  UIView+.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/11/05.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import UIKit

extension UIView {
    var size: CGSize {
        return bounds.size
    }

    var height: CGFloat {
        return size.height
    }

    var width: CGFloat {
        return size.width
    }

    var long: CGFloat {
        return size.height > size.width ? size.height : size.width
    }

    var short: CGFloat {
        return size.height > size.width ? size.width : size.height
    }

    var isPortrait: Bool {
        return height >= width
    }

    var safeArea: UIEdgeInsets {
        if #available(iOS 11, *) {
            return safeAreaInsets
        } else {
            return .zero
        }
    }

    var statusbarHeight: CGFloat {
        return UIApplication.shared.statusBarFrame.height
    }
}
