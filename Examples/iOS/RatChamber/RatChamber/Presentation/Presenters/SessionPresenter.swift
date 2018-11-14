//
//  SessionPresenter.swift
//  RatChamber
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import OperantKit
import RxCocoa
import RxSwift

public typealias ResponseDetail = (count: Int, time: Int)

final class SessionPresenter: Presenter {
    typealias ScheduleUseCaseType = ConcurrentScheduleUseCase
    typealias TimerUseCaseType = IntervalTimerUseCase
    typealias WireframeType = EmptyWireframe

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
    private let disposeBag = DisposeBag()

    init(scheduleUseCase: ScheduleUseCaseType,
         timerUseCase: TimerUseCaseType,
         wireframe: WireframeType) {
        self.scheduleUseCase = scheduleUseCase
        self.timerUseCase = timerUseCase
        self.wireframe = wireframe
    }

    func transform(input: SessionPresenter.Input) -> SessionPresenter.Output {
        let start: Driver<Void> = input.startTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.start() }
            .asDriverOnErrorJustComplete()

        let pause: Driver<Void> = input.pauseTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.pause() }
            .asDriverOnErrorJustComplete()

        let resume: Driver<Void> = input.resumeTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.resume() }
            .asDriverOnErrorJustComplete()

        let end: Driver<Void> = input.endTrigger
            .asObservable()
            .flatMap { [unowned self] in self.timerUseCase.finish() }
            .asDriverOnErrorJustComplete()

        var reinforcements: [(on: Driver<Void>, off: Driver<Void>)] = []

        input.responseTriggers.enumerated().forEach { [unowned self] i, e in
            let numOfResponse = e
                .scan(0) { n, _ in n + 1 }
                .asObservable()

            let milliseconds = e
                .asObservable()
                .flatMap { [unowned self] in self.timerUseCase.getInterval() }

            let response = Observable.zip(numOfResponse, milliseconds)
                .map { ResponseEntity(numOfResponse: $0.0, milliseconds: $0.1) }
                .do(onNext: { print("Response: \($0.milliseconds)") })
                .share(replay: 1)

            let reinforcement: Observable<Int> = self.scheduleUseCase
                .decision(response, number: i)
                .filter { $0.isReinforcement }
                .map { $0.entity.milliseconds }
                .asObservable()
                .share(replay: 1)

            let reinforcementOn: Driver<Void> = reinforcement
                .do(onNext: { print("SR on: \($0)") })
                .mapToVoid()
                .asDriverOnErrorJustComplete()

            let interReinforcementInterval = experimentEnitty.interReinforcementInterval
            let reinforcementOff: Driver<Void> = reinforcement
                .flatMap { [unowned self] in self.timerUseCase.delay(interReinforcementInterval, currentTime: $0) }
                .extend(time: interReinforcementInterval,
                        entities: scheduleUseCase.dataStore.concurrentEntity.subSchedules.map { $0.extendEntity })
                .do(onNext: { print("SR off: \($0)") })
                .mapToVoid()
                .asDriverOnErrorJustComplete()

            reinforcements.append((reinforcementOn, reinforcementOff))
        }

        return SessionPresenter.Output(start: start,
                                       pause: pause,
                                       resume: resume,
                                       end: end,
                                       reinforcements: reinforcements)
    }
}
