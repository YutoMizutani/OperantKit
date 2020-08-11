//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Variable ratio schedule
 ## VR logic
 The number of responses is greater than or equal the value.
 - Important: The order of the values is separated from decision logic to ensure the equality.
 - Complexity: O(1)
 */
example("VR - logic") {
    var numberOfResponses: Int
    let values = [3, 1]
    let order = 0

    numberOfResponses = 0
    print(numberOfResponses >= values[order])
    numberOfResponses = 1
    print(numberOfResponses >= values[order])
    numberOfResponses = 3
    print(numberOfResponses >= values[order])
    numberOfResponses = 5
    print(numberOfResponses >= values[order])
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important:
 The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.\
 The order of the values is separated from decision logic to ensure the equality.
 */
example("VR - Method chaining on the Rx stream") {
    let values = [3, 1]
    let order = 0

    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numberOfResponses: $0, milliseconds: 0) }
        .map { Single.just($0) }
        // The value is computed constant value. If input `VR(2)` is equal to `FR(2)`
        .flatMap { $0.VR(values[order]) }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("VR - Method chaining using UseCase on the Rx stream") {
    let schedule: ScheduleUseCase = VR(2, values: [1, 2])
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .count()
        .map { ResponseEntity($0, 0) }
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
