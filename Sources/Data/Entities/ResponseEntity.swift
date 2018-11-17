//
//  ResponseEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/28.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

public class ResponseEntity: Responsible {
    public var numOfResponse: Int
    public var milliseconds: Int

    public init(numOfResponse: Int = 0, milliseconds: Int = 0) {
        self.numOfResponse = numOfResponse
        self.milliseconds = milliseconds
    }
}

public extension ResponseEntity {
    static func - (lhs: ResponseEntity, rhs: ResponseEntity) -> ResponseEntity {
        return ResponseEntity(
            numOfResponse: lhs.numOfResponse - rhs.numOfResponse,
            milliseconds: lhs.milliseconds - rhs.milliseconds
        )
    }
}
