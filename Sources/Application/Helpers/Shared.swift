//
//  Shared.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/08.
//

import Foundation

public struct Shared<Element> {
    public var element: Element

    public init(_ element: Element) {
        self.element = element
    }
}
