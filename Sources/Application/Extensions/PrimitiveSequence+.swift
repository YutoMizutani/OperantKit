//
//  PrimitiveSequence+.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/28.
//

import RxSwift

public extension PrimitiveSequence {

    /**
     Projects each element of an single sequence into a new form.

     - seealso: [map operator on reactivex.io](http://reactivex.io/documentation/operators/map.html)

     - parameter transform: A transform function to apply to each source element.
     - returns: An observable sequence whose elements are the result of invoking the transform function on each element of source.

     */
    func map<R>(_ transform: @escaping (PrimitiveSequence.E) throws -> R) -> RxSwift.Single<R> {
        return asObservable().map(transform).asSingle()
    }

    /**
     Projects each element of an single sequence to an single sequence and merges the resulting single sequences into one single sequence.

     - seealso: [flatMap operator on reactivex.io](http://reactivex.io/documentation/operators/flatmap.html)

     - parameter selector: A transform function to apply to each element.
     - returns: An observable sequence whose elements are the result of invoking the one-to-many transform function on each element of the input sequence.
     */
    func flatMap<O>(_ selector: @escaping (PrimitiveSequence.E) throws -> O) -> RxSwift.Single<O.E> where O : ObservableConvertibleType {
        return asObservable().flatMap(selector).asSingle()
    }
}

public extension PrimitiveSequence {

    /// Store the last response and return tuple
    func store(startWith: PrimitiveSequence.E) -> Single<(newValue: E, oldValue: E)> {
        return asObservable().store(startWith: startWith).asSingle()
    }

    /// Store the last response and return tuple
    func store() -> Single<(newValue: E, oldValue: E?)> {
        return asObservable().store().asSingle()
    }
}
