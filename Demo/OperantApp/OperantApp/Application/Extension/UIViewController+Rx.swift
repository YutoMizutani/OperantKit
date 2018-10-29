//
//  RxSwift+.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

extension Reactive where Base: UIViewController {
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
