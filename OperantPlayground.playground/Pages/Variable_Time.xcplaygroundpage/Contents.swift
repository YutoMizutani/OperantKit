//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Variable time schedule
 ## VT logic
 The response milliseconds are greater than or equal the value.
 - Important: The order of the values is separated from decision logic to ensure the equality.
 - Complexity: O(1)
 */
example("VT - logic") {
    var milliseconds: Milliseconds
    let values = [3000, 1000]
    let order = 0

    milliseconds = 0
    print(milliseconds >= values[order])
    milliseconds = 1000
    print(milliseconds >= values[order])
    milliseconds = 3000
    print(milliseconds >= values[order])
    milliseconds = 5000
    print(milliseconds >= values[order])
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important:
 The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.\
 The order of the values is separated from decision logic to ensure the equality.
 */
example("VT - Method chaining on the Rx stream") {
    let values = [2000, 1000]
    let order = 0

    _ = Observable.of(0, 1000, 2000, 3000, 4000)
        .map { ResponseEntity(numOfResponses: 0, milliseconds: $0) }
        .map { Single.just($0) }
        // The value is computed constant value. If input `VT(2)` is equal to `FT(2)`
        .flatMap { $0.VT(values[order]) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("VT - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = VT(2000, values: [1000, 2000])
    let timer: TimerUseCase = StepTimerUseCase(1000)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .getTime(timer)
        .map { ResponseEntity(0, $0) }
        // If `isUpdateIfReinforcement` parameter is true, store the last SR value and count up the order automatically.
        .flatMap { schedule.decision($0, isUpdateIfReinforcement: true) }
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
