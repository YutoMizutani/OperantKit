//
//  ExperimentState.swift
//  FR
//
//  Created by Yuto Mizutani on 2020/02/19.
//

import State

protocol SessionState {}

enum ExperimentState<SessionStateType: SessionState> {
    case waitingToStart
    case inSession(SessionStateType)
    case pause
    case finished
}
typealias FreeOperantExperimentState = ExperimentState<FreeOperantSessionState>
enum FreeOperantSessionState: SessionState {
    case waiting
    case reinforcement
}

enum ResponseAction {
    case <#case#>
}

enum ExperimentAction<SessionTimeType: AdditiveArithmetic>: Action {
    case response(AnyResponse<SessionTimeType>)
    case time
}

struct Experiment {
}
struct Session {
}

public protocol ResponseCompatible {
    associatedtype SessionTime: AdditiveArithmetic

    var numberOfResponses: Int { get }
    var sessionTime: SessionTime { get }
}
public extension ResponseCompatible {
    func eraseToAnyResponse() -> AnyResponse<SessionTime> {
        AnyResponse<SessionTime>(
            numberOfResponses: numberOfResponses,
            sessionTime: sessionTime
        )
    }
}

public struct AnyResponse<SessionTimeType: AdditiveArithmetic>: ResponseCompatible {
    public typealias SessionTime = SessionTimeType

    public var numberOfResponses: Int
    public var sessionTime: SessionTimeType
}

struct Response: ResponseCompatible {
    var numberOfResponses: Int
    var sessionTime: Int
}
