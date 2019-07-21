//
//  ResponseEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public class ResponseEntity: Responsible {
    public var numberOfResponses: Int
    public var milliseconds: Milliseconds

    public var numOfResp: Int {
        set {
            numberOfResponses = newValue
        }
        get {
            return numberOfResponses
        }
    }

    public var ms: Milliseconds {
        set {
            milliseconds = newValue
        }
        get {
            return milliseconds
        }
    }

    public static var zero: ResponseEntity {
        return ResponseEntity(0, 0)
    }

    public init(numberOfResponses: Int = 0, milliseconds: Milliseconds = 0) {
        self.numberOfResponses = numberOfResponses
        self.milliseconds = milliseconds
    }

    public init(_ numberOfResponses: Int, _ milliseconds: Milliseconds) {
        self.numberOfResponses = numberOfResponses
        self.milliseconds = milliseconds
    }
}

extension ResponseEntity: Equatable {
    public static func == (lhs: ResponseEntity, rhs: ResponseEntity) -> Bool {
        return lhs.numberOfResponses == rhs.numberOfResponses
            && lhs.milliseconds == rhs.milliseconds
    }

    public static func + (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numberOfResponses: lhs.numberOfResponses + rhs.numberOfResponses,
            milliseconds: lhs.milliseconds + rhs.milliseconds
        )
    }

    public static func - (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numberOfResponses: lhs.numberOfResponses - rhs.numberOfResponses,
            milliseconds: lhs.milliseconds - rhs.milliseconds
        )
    }

    public static func += (lhs: inout ResponseEntity, rhs: ResponseEntity) {
        lhs.numberOfResponses += rhs.numberOfResponses
        lhs.milliseconds += rhs.milliseconds
    }

    public static func -= (lhs: inout ResponseEntity, rhs: ResponseEntity) {
        lhs.numberOfResponses -= rhs.numberOfResponses
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
            numberOfResponses: values.map { $0.numberOfResponses }.max()!,
            milliseconds: values.map { $0.milliseconds }.max()!
        )
    }

    /// Get each max elements
    ///
    /// - Complexity: O(1)
    func emax(_ value: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numberOfResponses: numberOfResponses > value.numberOfResponses ? numberOfResponses : value.numberOfResponses,
            milliseconds: milliseconds > value.milliseconds ? milliseconds : value.milliseconds
        )
    }
}
