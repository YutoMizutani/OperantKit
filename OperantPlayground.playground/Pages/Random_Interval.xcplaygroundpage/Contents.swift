//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Random interval schedule
 ## RI logic
 The response milliseconds are greater than or equal the value.
 - Important:
 The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.\
 The order of the values is separated from decision logic to ensure the equality.
 - Complexity: O(1)
 */
example("RI - logic") {
    var response: ResponseEntity
    var previousNumberOfResponses: Int
    let value = Milliseconds.random(in: 3000...3000)

    previousNumberOfResponses = 0
    response = ResponseEntity.zero
    print(response.numOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numOfResponses
    response = ResponseEntity(1, 1000)
    print(response.numOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numOfResponses
    response = ResponseEntity(2, 3000)
    print(response.numOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numOfResponses
    response = ResponseEntity(3, 5000)
    print(response.numOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numOfResponses
    response = ResponseEntity(4, 10000)
    print(response.numOfResponses > previousNumberOfResponses && response.milliseconds >= value)
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important:
 The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.\
 The order of the values is separated from decision logic to ensure the equality.
 */
example("RI - Method chaining on the Rx stream") {
    let value = Milliseconds.random(in: 2000...2000)

    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numOfResponses: $0, milliseconds: $0 * 1000) }
        .map { Single.just($0) }
        // The value is computed constant value. If input `RI(2)` is equal to `FI(2)`
        .flatMap { $0.RI(value) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("RI - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = RI(2, unit: .seconds)
    let timer: TimerUseCase = StepTimerUseCase(1000)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .response(timer)
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
