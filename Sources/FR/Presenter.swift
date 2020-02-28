//
//  Presenter.swift
//  FR
//
//  Created by Yuto Mizutani on 2020/02/19.
//

import Combine
import OperantKit
import State

@available(OSX 10.15, *)
class Presenter {
    typealias SessionTimeType = Int
    typealias ExperimentState = FreeOperantExperimentState
    typealias ActionType = ResponseAction<SessionTimeType>
    typealias ActionType = ResponseAction<SessionTimeType>

    @Published
    var state: ExperimentState

    init(initialState: ExperimentState = .waitingToStart) {
        self.state = initialState
    }

    private func transform(_ action: ActionType) ->

    func dispatch(_ action: ActionType) {
        switch action {
        case .response(let response):
            switch state {
            case .waitingToStart:
                debugPrint(state, response)
            case .inSession(let session):
                switch session {
                case .waiting:
                    break
                case .reinforcement:
                    break
                }
            case .pause, .finished:
                break
            }
        case .time:
            switch state {
            case .inSession(let session):
                switch session {
                case .waiting:
                    break
                case .reinforcement:
                    break
                }
            case .waitingToStart, .pause, .finished:
                break
            }
        }
    }
}
