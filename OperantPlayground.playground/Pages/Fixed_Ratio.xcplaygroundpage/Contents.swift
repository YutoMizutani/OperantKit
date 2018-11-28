//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Fixed ratio schedule
 ## FR logic
 The number of responses is greater than or equal the value.
 - Note: FR 1 schedule equals CRF schedule
 - Complexity: O(1)
 */
example("FR - logic") {
    var numberOfResponses: Int
    let value = 3

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
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 - Note: [`.FR(1)`](x-source-tag://.FR()) equals [`.CRF()`](x-source-tag://.CRF())
 */
example("FR - Method chaining on the Rx stream") {
    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numOfResponses: $0, milliseconds: 0) }
        .map { Single.just($0) }
        .flatMap { $0.FR(2) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 - Note: [`FR(1)`](x-source-tag://FR()) equals [`CRF()`](x-source-tag://CRF())
 */
example("FR") {
    let schedule: ScheduleUseCase = FR(2)
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
