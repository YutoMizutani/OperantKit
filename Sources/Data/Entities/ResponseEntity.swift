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

    public init(numOfResponses: Int = 0, milliseconds: Milliseconds = 0) {
        self.numOfResponses = numOfResponses
        self.milliseconds = milliseconds
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
