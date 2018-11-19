import OperantKit
import RxSwift
import RxCocoa

let timer = WhileLoopTimerUseCase(priority: .low)
let schedule: ScheduleUseCase = FR(5)
let responseAction = PublishSubject<Void>()
var disposeBag = DisposeBag()

let numOfResponse = responseAction
    .scan(0) { n, _ in n + 1 }
    .asObservable()

let milliseconds = responseAction
    .asObservable()
    .flatMap { _ in timer.elapsed() }

let response = Observable.zip(numOfResponse, milliseconds)
    .map { ResponseEntity(numOfResponse: $0.0, milliseconds: $0.1) }
    .do(onNext: { print("Response: \($0.numOfResponse), \($0.milliseconds)ms") })
    .share(replay: 1)

schedule.decision(response)
    .filter({ $0.isReinforcement })
    .subscribe(onNext: { _ in
        print("Reinforcement!!")
    })
    .disposed(by: disposeBag)

Observable.just(())
    .flatMap { timer.start() }
    .subscribe()
    .disposed(by: disposeBag)

var bool = true
while bool {
    print("Input: ", terminator: "")
    guard let input = readLine() else { continue }
    print("> \(input)")

    switch input {
    case "r", "":
        responseAction.onNext(())
    case "q":
        bool = false
    default:
        break
    }
}

Observable.just(())
    .flatMap { _ in timer.finish() }
    .subscribe(onNext: {
        print("Session finished: \($0)ms")
    })
    .disposed(by: disposeBag)
