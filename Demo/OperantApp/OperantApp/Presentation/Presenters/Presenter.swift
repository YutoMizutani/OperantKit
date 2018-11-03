//
//  Presenter.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import Foundation

protocol Presenter: class {
    associatedtype Input
    associatedtype Output

    func transform(input: Input) -> Output
}
