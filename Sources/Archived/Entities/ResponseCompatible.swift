//
//  ResponseCompatible.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/22.
//

import Foundation

/// Response parameter compatible
public protocol ResponseCompatible {
    /// Number of responses
    var numberOfResponses: Int { get set }
    /// Response time of the session
    var sessionTime: SessionTime { get set }
}

public extension ResponseCompatible {
    func asResponse() -> Response {
        return Response(self)
    }
}
