//
//  RatChamberViewController.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/25.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RatChamberViewController: UIViewController {
    @IBOutlet private weak var chamberView: RatChamberView!

    typealias PresenterType = SessionPresenter

    private var presenter: PresenterType?
    private let disposeBag = DisposeBag()

    func inject(presenter: PresenterType) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

//        let input = SessionPresenter.Input(
//            startTrigger: self.rx.viewDidLoad.mapToVoid()
//                .startWith(())
//                .asDriverOnErrorJustComplete(),
//            pauseTrigger: self.rx.viewDidDisappear
//                .mapToVoid()
//                .asDriverOnErrorJustComplete(),
//            endTrigger: self.rx.viewDidDisappear
//                .mapToVoid()
//                .asDriverOnErrorJustComplete(),
//            responseTriggers: [
//                self.leftLever.rx.tap
//                    .mapToVoid()
//                    .asDriverOnErrorJustComplete(),
//                self.rightLever.rx.tap
//                    .mapToVoid()
//                    .asDriverOnErrorJustComplete()
//            ]
//        )

//        guard let presenter = presenter else { return }
//
//        let output = presenter.transform(input: input)

//        Observable.merge(output.reinforcement)
//            .subscribe(onNext: { _ in
//                print("Reinforcement!!")
//            })
//            .disposed(by: self.disposeBag)
    }
}
