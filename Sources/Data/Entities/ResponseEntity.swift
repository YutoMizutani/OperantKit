//
//  ResponseEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public class ResponseEntity: Responsible {
    public var numOfResponses: Int
    public var milliseconds: Milliseconds
    public static let zero: ResponseEntity = ResponseEntity(0, 0)

    public init(numOfResponses: Int = 0, milliseconds: Milliseconds = 0) {
        self.numOfResponses = numOfResponses
        self.milliseconds = milliseconds
    }

    public init(_ numOfResponses: Int, _ milliseconds: Milliseconds) {
        self.numOfResponses = numOfResponses
        self.milliseconds = milliseconds
    }
}

extension ResponseEntity: Equatable {
    public static func == (lhs: ResponseEntity, rhs: ResponseEntity) -> Bool {
        return lhs.numOfResponses == rhs.numOfResponses
            && lhs.milliseconds == rhs.milliseconds
    }

    public static func + (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numOfResponses: lhs.numOfResponses + rhs.numOfResponses,
            milliseconds: lhs.milliseconds + rhs.milliseconds
        )
    }

    public static func - (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numOfResponses: lhs.numOfResponses - rhs.numOfResponses,
            milliseconds: lhs.milliseconds - rhs.milliseconds
        )
    }

    public static func += (lhs: inout ResponseEntity, rhs: ResponseEntity) {
        lhs.numOfResponses += rhs.numOfResponses
        lhs.milliseconds += rhs.milliseconds
    }

    public static func -= (lhs: inout ResponseEntity, rhs: ResponseEntity) {
        lhs.numOfResponses -= rhs.numOfResponses
        lhs.milliseconds -= rhs.milliseconds
    }
}

public extension ResponseEntity {

    /// Get each max elements
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    static func emax(_ values: [ResponseEntity]) -> ResponseEntity? {
        guard !values.isEmpty else { return nil }
        return ResponseEntity(
            numOfResponses: values.map { $0.numOfResponses }.max()!,
            milliseconds: values.map { $0.milliseconds }.max()!
        )
    }

    /// Get each max elements
    ///
    /// - Complexity: O(1)
    func emax(_ value: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numOfResponses: numOfResponses > value.numOfResponses ? numOfResponses : value.numOfResponses,
            milliseconds: milliseconds > value.milliseconds ? milliseconds : value.milliseconds
        )
    }
}
