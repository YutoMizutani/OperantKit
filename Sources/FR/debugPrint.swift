//
//  debugPrint.swift
//  FR
//
//  Created by Yuto Mizutani on 2020/02/19.
//

import Foundation

func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
    print(items, separator: separator, terminator: terminator)
    #endif
}
