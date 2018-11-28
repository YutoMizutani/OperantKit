//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Continuous reinforcement schedule
 ## CRF logic
 The number of responses is greater than or equal 1.
 - Note: CRF schedule equals FR 1 schedule
 - Complexity: O(1)
 */
example("CRF - logic") {
    var numberOfResponses: Int

    numberOfResponses = 0
    print(numberOfResponses >= 1)
    numberOfResponses = 1
    print(numberOfResponses >= 1)
    numberOfResponses = 3
    print(numberOfResponses >= 1)
    numberOfResponses = 5
    print(numberOfResponses >= 1)
}
/*:
 ---
 ## Method chaining on the Rx stream
 - Important: The feature of the decision function has only met the condition, so you should compute the current value before the decision if you compute from the last SR value.
 - Note: [`.CRF()`](x-source-tag://.CRF()) equals [`.FR(1)`](x-source-tag://.FR())
 */
example("CRF - Method chaining on the Rx stream") {
    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numOfResponses: $0, milliseconds: 0) }
        .map { Single.just($0) }
        .flatMap { $0.CRF() }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 - Note: [`CRF()`](x-source-tag://CRF()) equals [`FR(1)`](x-source-tag://FR())
 */
example("CRF") {
    let schedule: ScheduleUseCase = CRF()
    let responseTrriger = PublishSubject<Void>()

    responseTrriger
        .count()
        .map { ResponseEntity($0, 0) }
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
