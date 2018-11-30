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
}

public extension ResponseEntity {
    static func - (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numOfResponses: lhs.numOfResponses - rhs.numOfResponses,
            milliseconds: lhs.milliseconds - rhs.milliseconds
        )
    }
}
