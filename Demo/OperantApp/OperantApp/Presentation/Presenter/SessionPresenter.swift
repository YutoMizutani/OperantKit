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

    // TODO: REMOVE
    private let experimentEnitty = ExperimentEntity(interReinforcementInterval: 5000)

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
        let reinforcements: [(on: Driver<Void>, off: Driver<Void>)]
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

        var reinforcements: [(on: Driver<Void>, off: Driver<Void>)] = []

        input.responseTriggers.enumerated().forEach { arg in
            let (i, e) = arg
            var reinforcementEntity = ResponseEntity(numOfResponse: 0, milliseconds: 0)

            let num = e.map { i }
                .asObservable()

            let numOfResponse = e
                .scan(0) { n, _ in n + 1 }
                .map { $0 - reinforcementEntity.numOfResponse }
                .asObservable()

            let milliseconds = e
                .asObservable()
                .flatMapLatest { [unowned self] in self.timerUseCase.getInterval() }

            let response = Observable.zip(num, numOfResponse, milliseconds)
                .debug()
                .map { ($0.0, ResponseEntity(numOfResponse: $0.1, milliseconds: $0.2)) }
                .share(replay: 1)

            let reinforcement: Observable<Int> = response
                .filter { $0.0 == 0 }
                .flatMapLatest { [unowned self] in self.scheduleUseCase.decision($0.1) }
                .filter { $0 }
                .flatMapLatest { _ in self.timerUseCase.getInterval() }
                .asObservable()
                .share(replay: 1)

            // Update to set previous SR data
            reinforcement.asObservable().withLatestFrom(response.asObservable())
                .map { $0.1 }
                .subscribe(onNext: { response in
                    reinforcementEntity = ResponseEntity(
                        numOfResponse: reinforcementEntity.numOfResponse + response.numOfResponse,
                        milliseconds: response.milliseconds
                    )
                })
                .disposed(by: disposeBag)

            let reinforcementOn: Driver<Void>  = reinforcement
                .debug()
                .mapToVoid()
                .asDriverOnErrorJustComplete()

            let reinforcementOff: Driver<Void>  = reinforcement
                .flatMapLatest { self.timerUseCase.delay(self.experimentEnitty.interReinforcementInterval, currentTime: $0) }
                .debug()
                .mapToVoid()
                .asDriverOnErrorJustComplete()

            reinforcements.append((reinforcementOn, reinforcementOff))
        }

        func decision(schedule: FixedRatioSchedule, parameter: FixedRatioParameter) -> (ResponseDetail) -> Bool {
            return { schedule.decision($0.count, value: parameter.value) }
        }

        return SessionPresenter.Output(start: start,
                                       pause: pause,
                                       resume: resume,
                                       end: end,
                                       reinforcements: reinforcements)
    }
}
