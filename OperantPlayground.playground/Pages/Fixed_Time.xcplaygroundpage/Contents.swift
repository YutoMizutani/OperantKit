//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Fixed time schedule
 ## FT logic
 The response milliseconds is greater than or equal the value.
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 - Complexity: O(1)
 */
example("FT - logic") {
    var milliseconds: Milliseconds
    let value = 3000

    milliseconds = 0
    print(milliseconds >= value)
    milliseconds = 1000
    print(milliseconds >= value)
    milliseconds = 3000
    print(milliseconds >= value)
    milliseconds = 5000
    print(milliseconds >= value)
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 */
example("FT - Method chaining on the Rx stream") {
    _ = Observable.of(0, 1000, 2000, 3000, 4000)
        .map { ResponseEntity(numOfResponses: 0, milliseconds: $0) }
        .map { Single.just($0) }
        .flatMap { $0.FT(2000) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("FT - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = FT(2, unit: .seconds)
    let timer: TimerUseCase = StepTimerUseCase(1000)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .getTime(timer)
        .map { ResponseEntity(0, $0) }
        // If `isUpdateIfReinforcement` parameter is true, store the last SR value automatically.
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
