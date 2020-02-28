//
//  CompositeDisposable+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/08/26.
//

import RxCocoa
import RxSwift

public extension CompositeDisposable {
    @discardableResult
    func add(_ disposable: Disposable) -> DisposeKey? {
        return insert(disposable)
    }
}

public extension Disposable {
    @discardableResult
    func disposed(by disposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
        return disposable.insert(self)
    }
}

public extension ObservableType {
    @discardableResult
    func subscribeAndDisposed(by disposable: CompositeDisposable) -> CompositeDisposable.DisposeKey? {
        return disposable.insert(self.subscribe())
    }
}
