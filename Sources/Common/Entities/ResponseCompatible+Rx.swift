//
//  ResponseCompatible+Rx.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2019/07/23.
//

import RxSwift

public extension ObservableType where Element: ResponseCompatible {
    func asResponse() -> Observable<Response> {
        return map { Response($0) }
    }
}
