//
//  UIViewController+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

#if os(iOS)
import RxCocoa
import RxSwift
import UIKit

public extension UIViewController {
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
#endif
