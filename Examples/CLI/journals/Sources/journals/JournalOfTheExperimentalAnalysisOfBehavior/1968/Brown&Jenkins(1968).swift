//
//  Brown&Jenkins(1968).swift
//  journals
//
//  Created by Yuto Mizutani on 2018/11/16.
//

import RxSwift
import RxCocoa
import OperantKit

/// Brown, P. L., & Jenkins, H. M. (1968). AUTO‐SHAPING OF THE PIGEON'S KEY‐PECK 1. Journal of the experimental analysis of behavior, 11(1), 1-8.
/// - DOI: https://dx.doi.org/10.1901/jeab.1968.11-1
/// - Available link: https://www.ncbi.nlm.nih.gov/pmc/articles/PMC1338436/
class BrownAndJenkins1968 {
    func experiment1() {
        let numberOfPairings: Int = 80
        let whiteKeyLightDuration: Seconds = 8
        let trayOperatingDuration: Milliseconds = 4000
        let interTrialInterval: [Seconds] = [Seconds](5...10) // (30...90)
            .filter({ $0 % 5 == 0 })
            .map { TimeUnit.seconds.milliseconds($0) }
            .shuffled()

        var nextInterval: Milliseconds = 0
        var currentOrder: Int = 0
        func updateInterval() {
            nextInterval = interTrialInterval[currentOrder % interTrialInterval.count]
        }

        let timer = WhileLoopTimerUseCase(priority: .high)
        let schedule = DiscreteTrialUseCase(Alt(FT(whiteKeyLightDuration), CRF()))
        let responseAction = PublishSubject<Void>()
        let startTimerAction = PublishSubject<Void>()
        let finishTimerAction = PublishSubject<Void>()
        var isSessionFlag = true
        var disposeBag = DisposeBag()

        let respnseObservable = responseAction.response(timer)
            .do(onNext: { print("Response: \($0.numOfResponses), \($0.milliseconds)ms") })
            .share(replay: 1)

        let milliseconds = timer.milliseconds.shared

        _ = milliseconds
            .filter({ $0 % 1000 == 0 })
            .do(onNext: { print("Time elapsed: \($0)ms") })
            .subscribe()
            .disposed(by: disposeBag)

        let firstStart = milliseconds.take(1)

        firstStart
            .do(onNext: { _ in print("Session started") })
            .subscribe()
            .disposed(by: disposeBag)

        let timeObservable = milliseconds
            .map { ResponseEntity(0, $0) }

        let reinforcementOn = Observable.merge(respnseObservable, timeObservable)
            .flatMap { schedule.decision($0, isUpdateIfReinforcement: false) }
            .do(onNext: { print("### \($0.entity.milliseconds), \($0.entity.numOfResponses)") })
            .filter({ $0.isReinforcement })
            .share(replay: 1)

        let reinforcementOff = reinforcementOn
            .do(onNext: { print("SR on: \($0.entity.milliseconds)ms (IRI: \(trayOperatingDuration)ms)") })
            .flatMap { r in
                Single.zip(
                    schedule.addExtendsValue(ResponseEntity(0, trayOperatingDuration), isNext: false),
                    timer.delay(trayOperatingDuration, currentTime: r.entity.milliseconds)
                )
                .map { $0.1 }
            }
            .do(onNext: { print("SR off: \($0)ms") })
            .asObservable()
            .share(replay: 1)

        let nextTrial = Observable.merge(firstStart, reinforcementOff)
            .do(onNext: { _ in updateInterval() })
            .do(onNext: { print("ITI on: \($0)ms (Next ITI: \(nextInterval)ms)") })
            .flatMap {
                Single.zip(
                    schedule.addExtendsValue(ResponseEntity(0, nextInterval), isNext: false),
                    timer.delay(nextInterval, currentTime: $0)
                )
                .map { $0.1 }
            }
            .do(onNext: { print("ITI off: \($0)ms") })
            .asObservable()
            .share(replay: 1)

        nextTrial
            .do(onNext: { _ in print("SD on") })
            .flatMap { _ in schedule.nextTrial() }
            .subscribe()
            .disposed(by: disposeBag)

        reinforcementOn
            .do(onNext: { _ in print("SD off") })
            .subscribe()
            .disposed(by: disposeBag)

        reinforcementOff
            .count()
            .do(onNext: { print("Trial \($0)/\(numberOfPairings) finished") })
            .filter({ $0 >= numberOfPairings })
            .mapToVoid()
            .bind(to: finishTimerAction)
            .disposed(by: disposeBag)

        startTimerAction
            .flatMap { timer.start() }
            .subscribe()
            .disposed(by: disposeBag)

        finishTimerAction
            .flatMap { timer.finish() }
            .do(onNext: { print("Session finished: \($0)ms") })
            .do(onNext: { _ in print("Program ended if enter any keys") })
            .mapToVoid()
            .subscribe(onNext: {
                isSessionFlag = false
                disposeBag = DisposeBag()
            })
            .disposed(by: disposeBag)

        startTimerAction.onNext(())
        while isSessionFlag {
            let input = readLine()
            guard isSessionFlag else { continue }
            switch input {
            case "q":
                finishTimerAction.onNext(())
            default:
                responseAction.onNext(())
            }
        }
    }
}
