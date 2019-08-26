//
//  DeinitDisposable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxSwift

public class DeinitDisposable {
    public final let compositeDisposable = CompositeDisposable()

    deinit {
        compositeDisposable.dispose()
    }
}
