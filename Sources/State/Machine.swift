//
//  Machine.swift
//  
//
//  Created by Yuto Mizutani on 2020/02/19.
//

public protocol Machine {
    associatedtype CurrentState
    associatedtype NextState

    func transition(_ state: CurrentState) -> NextState
}
