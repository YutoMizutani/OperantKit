//
//  Helper.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift
@testable import OperantKit

extension Response {
    static func stub() -> Response {
        return Response(
            numberOfResponses: Int.random(in: 0...1000),
            milliseconds: Milliseconds.random(in: 0...1000)
        )
    }
}
