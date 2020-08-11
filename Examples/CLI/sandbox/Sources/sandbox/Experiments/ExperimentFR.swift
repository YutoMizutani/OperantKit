//
//  ExperimentFR.swift
//  CLI
//
//  Created by Yuto Mizutani on 2018/11/13.
//

import OperantKit
import RxSwift
import RxCocoa

struct ExperimentFR {
    init(_ value: Int) {
        let timer = WhileLoopTimer(priority: .low)
        let responseAction = PublishSubject<Void>()
        let startTimerAction = PublishSubject<Void>()
        let finishTimerAction = PublishSubject<Void>()
        let disposeBag = DisposeBag()

        let response = responseAction.response(timer)
            .do(onNext: { print("Response: \($0.numberOfResponses), \($0.milliseconds)ms") })

        let consequence = FR(value)
            .sessionTime(.seconds(2))
            .transform(response)

        consequence
            .filter { $0.isReinforcement }
            .subscribe(onNext: {
                print("Reinforcement: \($0.response.milliseconds) ms")
            }, onCompleted: {
                print("Session finished!")
            })
            .disposed(by: disposeBag)

        startTimerAction
            .flatMap { timer.start() }
            .subscribe(onNext: {
                print("Session started")
            })
            .disposed(by: disposeBag)

        finishTimerAction
            .flatMap { timer.finish() }
            .subscribe(onNext: {
                print("Session finished: \($0)ms")
            })
            .disposed(by: disposeBag)

        startTimerAction.onNext(())
        var bool = true
        while bool {
            switch readLine() {
            case "q":
                bool = false
            default:
                responseAction.onNext(())
            }
        }
        finishTimerAction.onNext(())
    }
}

extension ExperimentFR: Runnable {
    static func run() {
        while true {
            guard
                let value = InputHelper.value()
            else {
                continue
            }
            _ = ExperimentFR(value)
            break
        }
    }
}
