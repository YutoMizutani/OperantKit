//
//  File.swift
//  
//
//  Created by Yuto Mizutani on 2020/02/19.
//

import Combine

if #available(OSX 10.15, *) {
    var bool = true
    let presenter = Presenter()
    var cancellables: Set<AnyCancellable> = []

    presenter.$state
        .sink {
            print($0)
            switch $0 {
            case .finished:
                bool = false
            default:
                break
            }
        }
        .store(in: &cancellables)

    while bool {
        print("Input: ", terminator: "")
        guard let input = readLine() else { continue }
        print("> \(input)")

        switch input {
        case "r", "":
            presenter.dispatch(.response(<#T##AnyResponse<Presenter.SessionTimeType>#>))
            break
        case "q":
            bool = false
        default:
            break
        }
    }
}
