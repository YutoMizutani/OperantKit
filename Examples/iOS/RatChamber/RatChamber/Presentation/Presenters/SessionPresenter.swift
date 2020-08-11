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

public typealias ResponseDetail = (count: Int, time: Milliseconds)

final class SessionPresenter: Presenter {
    typealias ScheduleUseCaseType = ConcurrentScheduleUseCase
    typealias SessionTimerType = SessionTimer
    typealias WireframeType = EmptyWireframe

    // TODO: REMOVE
    private let experimentEntity = ExperimentEntity(interReinforcementInterval: 5000)

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
    private let timer: SessionTimerType
    private let wireframe: WireframeType
    private let disposeBag = DisposeBag()

    init(scheduleUseCase: ScheduleUseCaseType,
         timer: SessionTimerType,
         wireframe: WireframeType) {
        self.scheduleUseCase = scheduleUseCase
        self.timer = timer
        self.wireframe = wireframe
    }

    func transform(input: SessionPresenter.Input) -> SessionPresenter.Output {
        let start: Driver<Void> = input.startTrigger.asObservable()
            .flatMap { [unowned self] in self.timer.start() }
            .asDriverOnErrorJustComplete()

        let pause: Driver<Void> = input.pauseTrigger.asObservable()
            .flatMap { [unowned self] in self.timer.pause() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let resume: Driver<Void> = input.resumeTrigger.asObservable()
            .flatMap { [unowned self] in self.timer.resume() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        let end: Driver<Void> = input.endTrigger.asObservable()
            .flatMap { [unowned self] in self.timer.finish() }
            .mapToVoid()
            .asDriverOnErrorJustComplete()

        var reinforcements: [(on: Driver<Void>, off: Driver<Void>)] = []

        input.responseTriggers.enumerated().forEach { [unowned self] i, e in
            let response: Observable<ResponseEntity> = e.asObservable()
                .response(self.timer)
                .do(onNext: { print("Response(\(i)): (\($0.numOfResponses), \($0.milliseconds))") })

            let milliseconds: Observable<ResponseEntity> = self.timer.milliseconds.shared
                .map { ResponseEntity(0, $0) }

            let reinforcement: Observable<ResponseEntity> = Observable.merge(response, milliseconds)
                .flatMap { [unowned self] in self.scheduleUseCase.decision($0, index: i) }
                .filter { $0.isReinforcement }
                .map { $0.entity }
                .share(replay: 1)

            let reinforcementOn: Driver<Void> = reinforcement
                .do(onNext: { print("SR on: \($0.milliseconds)") })
                .mapToVoid()
                .asDriverOnErrorJustComplete()

            let interReinforcementInterval = experimentEntity.interReinforcementInterval
            let reinforcementOff: Driver<Void> = reinforcement
                .flatMap { [unowned self] r in
                    return Single.zip(
                        self.scheduleUseCase.addExtendsValue(ResponseEntity(0, interReinforcementInterval), isNext: false),
                        self.timer.delay(interReinforcementInterval, currentTime: r.milliseconds)
                    )
                    .map { $0.1 }
                }
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
