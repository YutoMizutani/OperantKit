import OperantKit
import RxSwift
import RxCocoa

let timer = WhileLoopTimerUseCase(priority: .default)
let schedule: ScheduleUseCase = FR(5)
let responseAction = PublishSubject<Void>()
var disposeBag = DisposeBag()

let response = responseAction.response(timer)
    .do(onNext: { print("Response: \($0.numOfResponses), \($0.milliseconds)ms") })

response
    .flatMap { schedule.decision($0) }
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
