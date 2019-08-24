//
//  Response.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/20.
//

import Foundation

public class Response: ResponseCompatible {
    public var numberOfResponses: Int
    public var milliseconds: Milliseconds

    public static var zero: Response {
        return Response(0, 0)
    }

    public init(numOfResp: Int = 0, ms: Milliseconds = 0) {
        numberOfResponses = numOfResp
        milliseconds = ms
    }

    public init(numberOfResponses: Int = 0, milliseconds: Milliseconds = 0) {
        self.numberOfResponses = numberOfResponses
        self.milliseconds = milliseconds
    }

    public init(_ numberOfResponses: Int, _ milliseconds: Milliseconds) {
        self.numberOfResponses = numberOfResponses
        self.milliseconds = milliseconds
    }

    public init(_ response: ResponseCompatible) {
        numberOfResponses = response.numberOfResponses
        milliseconds = response.milliseconds
    }
}

public extension Response {
    var numOfResp: Int {
        set {
            numberOfResponses = newValue
        }
        get {
            return numberOfResponses
        }
    }

    var ms: Milliseconds {
        set {
            milliseconds = newValue
        }
        get {
            return milliseconds
        }
    }
}

extension Response: Equatable {
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.numberOfResponses == rhs.numberOfResponses
            && lhs.milliseconds == rhs.milliseconds
    }

    public static func + (lhs: Response, rhs: Response) -> Response {
        return Response(
            numberOfResponses: lhs.numberOfResponses + rhs.numberOfResponses,
            milliseconds: lhs.milliseconds + rhs.milliseconds
        )
    }

    public static func - (lhs: Response, rhs: Response) -> Response {
        return Response(
            numberOfResponses: lhs.numberOfResponses - rhs.numberOfResponses,
            milliseconds: lhs.milliseconds - rhs.milliseconds
        )
    }

    public static func += (lhs: inout Response, rhs: Response) {
        lhs.numberOfResponses += rhs.numberOfResponses
        lhs.milliseconds += rhs.milliseconds
    }

    public static func -= (lhs: inout Response, rhs: Response) {
        lhs.numberOfResponses -= rhs.numberOfResponses
        lhs.milliseconds -= rhs.milliseconds
    }
}
