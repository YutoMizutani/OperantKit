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

public extension Reactive where Base: UIViewController {
    /// Called when viewDidLoad
    var viewDidLoad: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidLoad)).share(replay: 1)
    }

    /// Called when viewWillAppear
    var viewWillAppear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewWillAppear)).share(replay: 1)
    }

    /// Called when viewDidAppear
    var viewDidAppear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidAppear)).share(replay: 1)
    }

    /// Called when viewWillDisappear
    var viewWillDisappear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewWillDisappear)).share(replay: 1)
    }

    /// Called when viewDidDisappear
    var viewDidDisappear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidDisappear)).share(replay: 1)
    }
}

public extension UIViewController {
    /// A sample of start trigger
    var startTrigger: Driver<Void> {
        return rx.viewDidAppear
            .take(1)
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    /// A sample of pause trigger
    var pauseTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationDidEnterBackground
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    /// A sample of resume trigger
    var resumeTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationWillEnterForeground
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }

    /// A sample of end trigger
    var endTrigger: Driver<Void> {
        return UIApplication.shared.rx.applicationWillTerminate
            .mapToVoid()
            .asDriverOnErrorJustComplete()
    }
}
#endif
