//
//  Helper.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift
@testable import OperantKit

extension ResponseEntity {
    static func stub() -> ResponseEntity {
        return ResponseEntity(
            numOfResponse: Int.random(in: 0...1000),
            milliseconds: Int.random(in: 0...1000)
        )
    }
}
