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
        return self.sentMessage(#selector(self.base.viewDidLoad)).share(replay: 1)
    }

    var viewWillAppear: Observable<[Any]> {
        return self.sentMessage(#selector(self.base.viewWillAppear)).share(replay: 1)
    }

    var viewDidDisappear: Observable<[Any]> {
        return self.sentMessage(#selector(self.base.viewDidDisappear)).share(replay: 1)
    }
}
