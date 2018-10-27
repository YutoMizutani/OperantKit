//
//  SessionPresenter.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxCocoa
import RxSwift

public typealias ResponseDetail = (count: Int, time: Int)

final class SessionPresenter: Presenter {
    typealias UseCaseType = EmptyUseCase
    typealias TimerUseCaseType = IntervalTimerUseCase
    typealias WireframeType = EmptyWireframe
    typealias ExperimentType = FixedRatioExperiment

    struct Input {
        let startTrigger: Driver<Void>
        let pauseTrigger: Driver<Void>
        let endTrigger: Driver<Void>
        let responseTriggers: [Driver<Void>]
    }

    struct Output {
        let start: Driver<Void>
        let pause: Driver<Void>
        let end: Driver<Void>
        let reinforcement: [Observable<Void>]
    }

    private let useCase: UseCaseType
    private let timerUseCase: TimerUseCaseType
    private let wireframe: WireframeType
    private let experiment: ExperimentType
    private let disposeBag = DisposeBag()

    init(useCase: UseCaseType,
         timerUseCase: TimerUseCaseType,
         wireframe: WireframeType,
         experiment: ExperimentType) {
        self.useCase = useCase
        self.timerUseCase = timerUseCase
        self.wireframe = wireframe
        self.experiment = experiment
    }

    func transform(input: SessionPresenter.Input) -> SessionPresenter.Output {
        let start: Driver<Void> = input.startTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.start() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let pause: Driver<Void> = input.pauseTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.pause() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let end: Driver<Void> = input.endTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.finish() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        input.responseTriggers.enumerated().forEach { arg in
            let (i, e) = arg

            let num = e.map { i }
                .asObservable()

            let numOfResponse = e
                .scan(0) { n, _ in n + 1 }
                .asObservable()

            let milliseconds = e
                .asObservable()
                .flatMapLatest { [unowned self] in self.timerUseCase.getInterval() }

            Observable.zip(num, numOfResponse, milliseconds)
                .debug()
                .subscribe()
                .disposed(by: disposeBag)
        }

        func decision(schedule: FixedRatioSchedule, parameter: FixedRatioParameter) -> (ResponseDetail) -> Bool {
            return { schedule.decision($0.count, value: parameter.value) }
        }
//        let decisionSchedule: (ResponseDetail) -> Bool = decision(schedule: self.experiment.schedule, parameter: self.experiment.parameter)

//        let reinforcement: [Observable<Void>] = input.responseTriggers.enumerated()
//            .map { [unowned self] in
//                $0.element.asObservable()
//                    .scan(0) { n, _ in n + 1 }
//                    .getResponse(1)
//                    .filter({ decisionSchedule($0) })
//                    .mapToVoid()
//                    .share(replay: 1)
//            }

        return SessionPresenter.Output(start: start,
                                       pause: pause,
                                       end: end,
                                       reinforcement: [])
    }
}
