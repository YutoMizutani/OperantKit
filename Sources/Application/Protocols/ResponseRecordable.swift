//
//  ResponseRecordable.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/18.
//

import Foundation

public protocol ResponseRecordable {
    /// Max reponses
    var maxRecords: [ResponseEntity] { get set }
    /// Last SR entities
    var lastReinforcementEntities: [ResponseEntity] { get set }
}
