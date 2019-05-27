//
//  ViewController.swift
//  Sandbox
//
//  Created by ym on 2019/03/18.
//  Copyright © 2019 Yuto Mizutani. All rights reserved.
//

import Cocoa
import OperantKit
import RxSwift
import RxCocoa
import QuartzCore

class ViewController: NSViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        _ = ExperimentFT(5, .seconds)
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

//
//  ExperimentFT.swift
//  sandbox
//
//  Created by Yuto Mizutani on 2018/11/14.
//

struct ExperimentFT {
    init(_ value: Int, _ unit: TimeUnit) {
        let timer = CVDisplayLinkTimerUseCase()
        let schedule: ScheduleUseCase = FT(value, unit: unit)
        let responseAction = PublishSubject<Void>()
        let startTimerAction = PublishSubject<Void>()
        let finishTimerAction = PublishSubject<Void>()
        let disposeBag = DisposeBag()

        _ = responseAction.response(timer)
            .do(onNext: { print("Response: \($0.numOfResponses), \($0.milliseconds)ms") })
            .subscribe()
            .disposed(by: disposeBag)

        let timeObservable = timer.milliseconds.shared
            .map { ResponseEntity(0, $0) }

        timeObservable
            .flatMap { schedule.decision($0) }
            .filter({ $0.isReinforcement })
            .subscribe(onNext: {
                print("Reinforcement: \($0.entity.milliseconds)ms")
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

extension ExperimentFT: Runnable {
    static func run() {
        while true {
            guard
                let value = InputHelper.value(),
                let unit = InputHelper.unit()
                else {
                    continue
            }
            _ = ExperimentFT(value, unit)
            break
        }
    }
}

//
//  InputHelper.swift
//  sandbox
//
//  Created by Yuto Mizutani on 2018/11/14.
//

struct InputHelper {
    static func value() -> Int? {
        print("Value: ", terminator: "")
        return Int(readLine() ?? "")
    }

    static func unit() -> TimeUnit? {
        print("Unit [", terminator: "")
        TimeUnit.allCases.enumerated().forEach {
            print("\($0.offset + 1). \($0.element.longName)",
                terminator: $0.element.shortName != TimeUnit.allCases.last?.shortName ? ", " : "")
        }
        print("]: ", terminator: "")
        guard let unitNum = Int(readLine() ?? "") else { return nil }
        return TimeUnit.allCases.enumerated().first(where: { $0.offset + 1 == unitNum })?.element
    }
}

//
//  Runnable.swift
//  CLI
//
//  Created by Yuto Mizutani on 2018/11/13.
//

protocol Runnable {
    static func run()
}
