//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Fixed interval schedule
 ## FI logic
 The response milliseconds are greater than or equal the value.
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 - Complexity: O(1)
 */
example("FI - logic") {
    var response: ResponseEntity
    var previousNumberOfResponses: Int
    let value = 3000

    previousNumberOfResponses = 0
    response = ResponseEntity.zero
    print(response.numberOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numberOfResponses
    response = ResponseEntity(1, 1000)
    print(response.numberOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numberOfResponses
    response = ResponseEntity(2, 3000)
    print(response.numberOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numberOfResponses
    response = ResponseEntity(3, 5000)
    print(response.numberOfResponses > previousNumberOfResponses && response.milliseconds >= value)
    previousNumberOfResponses = response.numberOfResponses
    response = ResponseEntity(4, 10000)
    print(response.numberOfResponses > previousNumberOfResponses && response.milliseconds >= value)
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 */
example("FI - Method chaining on the Rx stream") {
    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numberOfResponses: $0, milliseconds: $0 * 1000) }
        .map { Single.just($0) }
        .flatMap { $0.FI(2000) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("FI - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = FI(2, unit: .seconds)
    let timer: SessionTimer = StepTimer(1000)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .response(timer)
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
