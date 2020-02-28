//
//  Readonly.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2020/02/19.
//

import Foundation

@propertyWrapper
public struct Readonly<V> {
    private var value: V!

    public var wrappedValue: V {
        get { value }
        set {
            value = newValue
        }
    }

    public init() {}
}
