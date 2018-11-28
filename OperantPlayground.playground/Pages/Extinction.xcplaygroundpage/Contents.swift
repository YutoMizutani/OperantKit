//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Extinction schedule
 ## EXT logic
 Always return false
 - Complexity: O(1)
 */
example("EXT - logic") {
    var numberOfResponses: Int

    numberOfResponses = 0
    print(false)
    numberOfResponses = 1
    print(false)
    numberOfResponses = 3
    print(false)
    numberOfResponses = 5
    print(false)
}
/*:
 ---
 ## Method chaining on the Rx stream
 */
example("EXT - Method chaining on the Rx stream") {
    _ = Observable.of(0, 1, 2, 3, 4)
        .map { ResponseEntity(numOfResponses: $0, milliseconds: 0) }
        .map { Single.just($0) }
        .flatMap { $0.EXT() }
        .asObservable()
        .subscribe { event in
            print(event)
        }
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("EXT") {
    let schedule: ScheduleUseCase = EXT()
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
