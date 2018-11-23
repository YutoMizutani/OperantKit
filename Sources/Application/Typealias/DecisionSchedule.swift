//
//  DecisionSchedule.swift
//  OperantKit
//
//  Created by Yuto Mizutani on 2018/11/01.
//

import RxSwift

public typealias DecisionSchedule = ((Observable<ResponseEntity>) -> Observable<ResultEntity>)
