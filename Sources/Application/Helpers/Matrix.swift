//
//  Matrix.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/07.
//

import Foundation

public struct Matrix<Element> {
    public var elements: [Element]
    public let rows: Int
    public let columns: Int

    public init(elements: [Element], rows: Int, columns: Int) {
        self.elements = elements
        self.rows = rows
        self.columns = columns
    }

    public init?(elements: [Element], rows: Int) {
        guard elements.count % rows == 0 else { return nil }
        self.elements = elements
        self.rows = rows
        self.columns = elements.count / rows
    }

    public init?(elements: [Element], columns: Int) {
        guard elements.count % columns == 0 else { return nil }
        self.elements = elements
        self.columns = columns
        self.rows = elements.count / columns
    }
}
