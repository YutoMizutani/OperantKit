//
//  Priority.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/19.
//

import Foundation

public enum Priority {
    case immediate, high, `default`, low, manual(UInt32)
}
