//: [Previous](@previous)
import OperantKit
import RxCocoa
import RxSwift
/*:
 # Alternative schedule
 ## Alternative logic
 The two or more result is merged.
 - Complexity: O(2)
 */
example("FR - logic") {
    var results: [Bool]

    results = [false, false]
    print(!results.filter({ $0 }).isEmpty)
    results = [true, false]
    print(!results.filter({ $0 }).isEmpty)
    results = [false, true]
    print(!results.filter({ $0 }).isEmpty)
    results = [true, false, false, false, false]
    print(!results.filter({ $0 }).isEmpty)
}
/*:
 ---
 ## Method chaining using UseCase on the Rx stream
 */
example("FR") {
    let schedule: ScheduleUseCase = Alt(FR(2), FR(3))
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
