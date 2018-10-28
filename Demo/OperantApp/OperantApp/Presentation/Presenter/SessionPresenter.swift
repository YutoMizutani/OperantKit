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
    typealias ScheduleUseCaseType = ScheduleUseCase
    typealias TimerUseCaseType = IntervalTimerUseCase
    typealias WireframeType = EmptyWireframe
    typealias ExperimentType = FixedRatioExperiment

    struct Input {
        let startTrigger: Driver<Void>
        let pauseTrigger: Driver<Void>
        let resumeTrigger: Driver<Void>
        let endTrigger: Driver<Void>
        let responseTriggers: [Driver<Void>]
    }

    struct Output {
        let start: Driver<Void>
        let pause: Driver<Void>
        let resume: Driver<Void>
        let end: Driver<Void>
        let reinforcement: [Observable<Void>]
    }

    private let scheduleUseCase: ScheduleUseCaseType
    private let timerUseCase: TimerUseCaseType
    private let wireframe: WireframeType
    private let experiment: ExperimentType
    private let disposeBag = DisposeBag()

    init(scheduleUseCase: ScheduleUseCaseType,
         timerUseCase: TimerUseCaseType,
         wireframe: WireframeType,
         experiment: ExperimentType) {
        self.scheduleUseCase = scheduleUseCase
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

        let resume: Driver<Void> = input.resumeTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.resume() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let end: Driver<Void> = input.endTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.finish() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        var reinforcement: [Observable<Void>] = []

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

            reinforcement.append(
                Observable.zip(num, numOfResponse, milliseconds)
                    .debug()
                    .filter { $0.0 == 0 }
                    .map { ResponseEntity(numOfResponse: $0.1, milliseconds: $0.2) }
                    .flatMapLatest { [unowned self] in self.scheduleUseCase.decision($0) }
                    .filter { $0 }
                    .mapToVoid()
                    .share(replay: 1)
            )
        }

        func decision(schedule: FixedRatioSchedule, parameter: FixedRatioParameter) -> (ResponseDetail) -> Bool {
            return { schedule.decision($0.count, value: parameter.value) }
        }

        return SessionPresenter.Output(start: start,
                                       pause: pause,
                                       resume: resume,
                                       end: end,
                                       reinforcement: reinforcement)
    }
}
