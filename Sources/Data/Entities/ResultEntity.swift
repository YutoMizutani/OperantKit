//
//  ResultEntity.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/23.
//

import Foundation

public struct ResultEntity {
    public var isReinforcement: Bool
    public var entity: ResponseEntity

    public init(_ isReinforcement: Bool, _ entity: ResponseEntity) {
        self.isReinforcement = isReinforcement
        self.entity = entity
    }

    public init(isReinforcement: Bool, entity: ResponseEntity) {
        self.isReinforcement = isReinforcement
        self.entity = entity
    }
}
