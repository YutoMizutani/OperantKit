//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Random ratio schedule
 ## RR logic
 The number of responses is greater than or equal the value.
 - Important: The random value is separated from decision logic to ensure the equality.
 - Complexity: O(1)
 */
example("RR - logic") {
    var numberOfResponses: Int
    let value = Int.random(in: 3...3)

    numberOfResponses = 0
    print(numberOfResponses >= value)
    numberOfResponses = 1
    print(numberOfResponses >= value)
    numberOfResponses = 3
    print(numberOfResponses >= value)
    numberOfResponses = 5
    print(numberOfResponses >= value)
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important:
 The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.\
 The random value is separated from decision logic to ensure the equality.
 */
example("RR - Method chaining on the Rx stream") {
    let value = Int.random(in: 2...2)

    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numberOfResponses: $0, milliseconds: 0) }
        .map { Single.just($0) }
        // The value is computed constant value. If input `RR(2)` is equal to `FR(2)`
        .flatMap { $0.RR(value) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("RR - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = RR(2)
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .count()
        .map { ResponseEntity($0, 0) }
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
