//
//  Experiment.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/10/21.
//

import Foundation

public protocol Experiment {
    associatedtype Schedulable
    associatedtype Parameterable
    associatedtype Stateable

    var schedule: Schedulable { get }
    var parameter: Parameterable { get }
    var state: Stateable { get }
}
