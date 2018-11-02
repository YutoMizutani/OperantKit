//
//  EXT.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

extension Observable where E == ResponseEntity {

    /// Extinction schedule
    public func EXT() -> Observable<ReinforcementResult> {
        return self
            .extension()
    }

    /// EXT logic
    func `extension`() -> Observable<ReinforcementResult> {
        return self.map { (false, $0) }
    }
}
