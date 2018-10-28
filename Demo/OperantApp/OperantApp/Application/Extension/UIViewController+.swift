//
//  UIViewController+.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension UIViewController {
    var startTrigger: Driver<Void> {
        return rx.viewDidAppear
            .take(1)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    var pauseTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationDidEnterBackground
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    var resumeTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationWillEnterForeground
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    var endTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationWillTerminate
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
}
