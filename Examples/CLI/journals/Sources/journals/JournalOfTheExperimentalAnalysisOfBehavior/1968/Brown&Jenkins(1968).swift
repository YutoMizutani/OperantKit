//
//  Brown&Jenkins(1968).swift
//  journals
//
//  Created by Yuto Mizutani on 2018/11/16.
//

import RxSwift
import RxCocoa
import OperantKit

public extension ObservableType {
    func count() -> Observable<Int> {
        return scan(0) { n, _ in n + 1 }
    }

    func getTime(_ timer: TimerUseCase) -> Observable<Milliseconds> {
        return flatMap { _ in timer.elapsed() }
    }

    func response(_ timer: TimerUseCase) -> Observable<ResponseEntity> {
        return Observable.zip(count(), getTime(timer))
            .map { ResponseEntity.init(numOfResponses: $0.0, milliseconds: $0.1) }
    }
}

public extension PublishSubject where E == Milliseconds {
    var shared: Observable<E> {
        return distinctUntilChanged()
            .share(replay: 1)
    }
}

///

public enum ExitCondition {
    case reinforcement(Int)
    case time(Milliseconds)
}

public protocol TrialParameter {
    var schedules: [ScheduleUseCase] { get }
    var exitCondition: ExitCondition { get }
}

public protocol TrialRecordable {
    var startTime: Milliseconds { get set }
    var startEntities: ResponseEntity { get set }
}

public protocol DiscreteTrialParameter {
    var maxTrials: Int { get }
    var trials: Matrix<TrialParameter> { get }
}

public protocol DiscreteTrialRecordable {
    var trials: Matrix<TrialRecordable> { get }
}

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
        let fixedTimeSchedule = FT(whiteKeyLightDuration)
        let continuousReinforcementSchedule = CRF()
        let responseAction = PublishSubject<Void>()
        let startTimerAction = PublishSubject<Void>()
        let finishTimerAction = PublishSubject<Void>()
        var isSessionFlag = true
        let duringSR = BehaviorRelay<Bool>(value: false)
        var disposeBag = DisposeBag()

        let respnseObservable = responseAction.response(timer)
            .do(onNext: { print("Response: \($0.numOfResponses), \($0.milliseconds)ms") })

        let milliseconds = timer.milliseconds.shared
            .filter({ $0 % 1000 == 0 })

        let firstStart = milliseconds.take(1)

        firstStart
            .do(onNext: { _ in print("Session started") })
            .subscribe()
            .disposed(by: disposeBag)

        let timeObservable = milliseconds
            .do(onNext: { print("Time elapsed: \($0)ms") })
            .map { ResponseEntity(numOfResponses: 0, milliseconds: $0) }
            .share(replay: 1)

        let reinforcementOn = Observable<ReinforcementResult>.merge(
                fixedTimeSchedule.decision(timeObservable),
                continuousReinforcementSchedule.decision(respnseObservable)
            )
            .filter({ _ in !duringSR.value })
            .filter({ $0.isReinforcement })
            .share(replay: 1)

        let reinforcementOff = reinforcementOn
            .do(onNext: { print("SR on: \($0.entity.milliseconds)ms (IRI: \(trayOperatingDuration)ms)") })
            .storeResponse(fixedTimeSchedule.dataStore.lastReinforcementEntity, condition: { $0.isReinforcement })
            .extend(time: trayOperatingDuration, entities: fixedTimeSchedule.extendEntity)
            .flatMap { timer.delay(trayOperatingDuration, currentTime: $0.entity.milliseconds) }
            .do(onNext: { print("SR off: \($0)ms") })
            .asObservable()
            .share(replay: 1)

        let nextTrial = Observable<Milliseconds>.merge(
            firstStart,
            reinforcementOff
            )
            .do(onNext: { _ in updateInterval() })
            .do(onNext: { print("ITI on: \($0)ms (Next ITI: \(nextInterval)ms)") })
            .extend(time: { nextInterval }, entities: fixedTimeSchedule.extendEntity)
            .flatMap { timer.delay(nextInterval, currentTime: $0) }
            .do(onNext: { print("ITI off: \($0)ms") })
            .asObservable()
            .share(replay: 1)

        nextTrial
            .do(onNext: { _ in print("SD on") })
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

        Observable<Bool>.merge(
            reinforcementOn.map { _ in true },
            reinforcementOff.map { _ in false }
            )
            .bind(to: duringSR)
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
