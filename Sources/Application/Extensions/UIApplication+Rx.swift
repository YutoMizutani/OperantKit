//
//  UIApplication+Rx.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

#if os(iOS)
import RxCocoa
import RxSwift
import UIKit

extension UIApplication: HasDelegate {
    public typealias Delegate = UIApplicationDelegate
}

public class RxUIApplicationDelegateProxy: DelegateProxy<UIApplication, UIApplicationDelegate>, DelegateProxyType, UIApplicationDelegate {
    public weak private(set) var application: UIApplication?

    public init(application: UIApplication) {
        self.application = application
        super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxUIApplicationDelegateProxy(application: $0) }
    }

    override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?, retainDelegate: Bool) {
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
    }
}

public extension RxSwift.Reactive where Base: UIApplication {
    var delegate: RxUIApplicationDelegateProxy {
        return RxUIApplicationDelegateProxy.proxy(for: base)
    }

    var applicationWillEnterForeground: Observable<[Any]> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:))).share(replay: 1)
    }

    var applicationDidBecomeActive: Observable<[Any]> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:))).share(replay: 1)
    }

    var applicationDidEnterBackground: Observable<[Any]> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:))).share(replay: 1)
    }

    var applicationWillResignActive: Observable<[Any]> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:))).share(replay: 1)
    }

    var applicationWillTerminate: Observable<[Any]> {
        return delegate.methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:))).share(replay: 1)
    }
}
#endif
