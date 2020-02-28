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
    var viewDidLoad: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidLoad)).share(replay: 1)
    }

    var viewWillAppear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewWillAppear)).share(replay: 1)
    }

    var viewDidAppear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidAppear)).share(replay: 1)
    }

    var viewWillDisappear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewWillDisappear)).share(replay: 1)
    }

    var viewDidDisappear: Observable<[Any]> {
        return self.methodInvoked(#selector(self.base.viewDidDisappear)).share(replay: 1)
    }
}

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
