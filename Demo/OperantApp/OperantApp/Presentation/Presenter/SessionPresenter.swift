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
//    typealias UseCaseType = WatchingUseCase
//    typealias WireframeType = WatchingWireframe
    typealias TimerType = IntervalTimer
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

//    private let useCase: UseCaseType
//    private let wireframe: WireframeType
    private let timer: TimerType
    private let experiment: ExperimentType
    private let disposeBag = DisposeBag()

//    init(useCase: UseCaseType, wireframe: WireframeType) {
//        self.useCase = useCase
//        self.wireframe = wireframe
//    }

    init(timer: TimerType, experiment: ExperimentType) {
        self.timer = timer
        self.experiment = experiment
    }

    func transform(input: SessionPresenter.Input) -> SessionPresenter.Output {
        let start: Driver<Void> = input.startTrigger
            .do { [weak self] in self?.timer.start() }

        let pause: Driver<Void> = input.pauseTrigger
            .do { [weak self] in self?.timer.sleep() }

        let end: Driver<Void> = input.endTrigger
            .do { [weak self] in self?.timer.finish() }

        func decision(schedule: FixedRatioSchedule, parameter: FixedRatioParameter) -> (ResponseDetail) -> Bool {
            return { schedule.decision($0.count, value: parameter.value) }
        }
        let decisionSchedule: (ResponseDetail) -> Bool = decision(schedule: self.experiment.schedule, parameter: self.experiment.parameter)

        let reinforcement: [Observable<Void>] = input.responseTriggers.enumerated()
            .map { [unowned self] in
                $0.element.asObservable()
                    .scan(0) { n, _ in n + 1 }
                    .getResponse(self.timer)
                    .debug()
                    .filter({ decisionSchedule($0) })
                    .mapToVoid()
            }

        return SessionPresenter.Output(start: start,
                                       pause: pause,
                                       end: end,
                                       reinforcement: reinforcement)
    }
}

public extension Observable {
    func interval(_ timer: IntervalTimer) -> Observable<Int> {
        return map { _ in timer.elapsed.milliseconds.now.value }
    }
}

public extension Observable where E == Int {
    func getResponse(_ timer: IntervalTimer) -> Observable<ResponseDetail> {
        return map { ($0, timer.elapsed.milliseconds.now.value) }
    }
}

extension ObservableType {
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }

    func asDriverOnErrorJustComplete() -> Driver<E> {
        return asDriver { error in
            assertionFailure("Error \(error)")
            return Driver.empty()
        }
    }
}
