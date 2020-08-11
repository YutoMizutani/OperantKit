//
//  Response.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/20.
//

import Foundation

public class Response: ResponseCompatible {
    public var numberOfResponses: Int
    public var sessionTime: SessionTime

    public static var zero: Response {
        return Response(0, 0)
    }

    public init(numOfResp: Int = 0, ms: Milliseconds = 0) {
        numberOfResponses = numOfResp
        sessionTime = SessionTime(ms)
    }

    public init(numberOfResponses: Int = 0, milliseconds: Milliseconds = 0) {
        self.numberOfResponses = numberOfResponses
        self.sessionTime = SessionTime(milliseconds)
    }

    public init(numberOfResponses: Int, sessionTime: SessionTime) {
        self.numberOfResponses = numberOfResponses
        self.sessionTime = sessionTime
    }

    public init(_ numberOfResponses: Int, _ milliseconds: Milliseconds) {
        self.numberOfResponses = numberOfResponses
        self.sessionTime = SessionTime(milliseconds)
    }

    public init(_ response: ResponseCompatible) {
        numberOfResponses = response.numberOfResponses
        sessionTime = response.sessionTime
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

    var time: SessionTime {
        set {
            sessionTime = newValue
        }
        get {
            return sessionTime
        }
    }
}

extension Response: Equatable {
    public static func == (lhs: Response, rhs: Response) -> Bool {
        return lhs.numberOfResponses == rhs.numberOfResponses
            && lhs.sessionTime == rhs.sessionTime
    }

    public static func + (lhs: Response, rhs: Response) -> Response {
        return Response(
            numberOfResponses: lhs.numberOfResponses + rhs.numberOfResponses,
            sessionTime: lhs.sessionTime + rhs.sessionTime
        )
    }

    public static func - (lhs: Response, rhs: Response) -> Response {
        return Response(
            numberOfResponses: lhs.numberOfResponses - rhs.numberOfResponses,
            sessionTime: lhs.sessionTime - rhs.sessionTime
        )
    }

    public static func += (lhs: inout Response, rhs: Response) {
        lhs.numberOfResponses += rhs.numberOfResponses
        lhs.sessionTime += rhs.sessionTime
    }

    public static func -= (lhs: inout Response, rhs: Response) {
        lhs.numberOfResponses -= rhs.numberOfResponses
        lhs.sessionTime -= rhs.sessionTime
    }
}
