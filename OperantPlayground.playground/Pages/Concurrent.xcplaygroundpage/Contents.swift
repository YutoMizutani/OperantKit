//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Concurrent schedule
 ## Concurrent logic
 The result of orders.
 - Complexity: O(1)
 */
example("Conc - logic") {
    var results: [Bool]
    var index = 0

    results = [false, false]
    order = 0
    print(results[index])
    results = [true, false]
    order = 1
    print(results[index])
    results = [false, true]
    order = 1
    print(results[index])
    results = [false, true, false, true, false]
    order = 3
    print(results[index])
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("Conc - Method chaining using UseCase on the Rx stream") {
    let schedule: ConcurrentScheduleUseCase = Conc(FR(2), FR(3))
    let timer: TimerUseCase = StepTimerUseCase(1000)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .response(timer)
        .map { (response: $0, index: 1) }
        // If `isUpdateIfReinforcement` parameter is true, store the last SR value automatically.
        .flatMap { schedule.decision($0.response, index: $0.index, isUpdateIfReinforcement: true) }
        .subscribe(onNext: { resultEntity in
            print(resultEntity.isReinforcement)
        })

    _ = Observable<Void>.create { observer in
        observer.on(.next(()))
        observer.on(.next(()))
        observer.on(.next(()))
        observer.on(.next(()))
        observer.on(.next(()))
        observer.on(.completed)
        return Disposables.create()
    }
        .bind(to: responseTrriger)
}
//: [Next](@next) - [Table of Contents](Table_of_Contents)
