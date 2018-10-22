//
//  RatChamberView.swift
//  OperantApp
//
//  Created by Yuto Mizutani on 2018/10/22.
//  Copyright © 2018 Yuto Mizutani. All rights reserved.
//

import RxCocoa
import RxSwift
import UIKit

class RatChamberView: UIViewController {
    @IBOutlet private weak var baseView: RatChamberBaseView!
    @IBOutlet private weak var leftLight: RatChamberLightView!
    @IBOutlet private weak var rightLight: RatChamberLightView!
    @IBOutlet private weak var leftLever: RatChamberLeverButton!
    @IBOutlet private weak var rightLever: RatChamberLeverButton!

    typealias PresenterType = SessionPresenter

    private var presenter: PresenterType?
    private let disposeBag = DisposeBag()

    func inject(presenter: PresenterType) {
        self.presenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let input = SessionPresenter.Input(
            startTrigger: self.rx.viewDidLoad.mapToVoid()
                .startWith(())
                .asDriverOnErrorJustComplete(),
            pauseTrigger: self.rx.viewDidDisappear
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            endTrigger: self.rx.viewDidDisappear
                .mapToVoid()
                .asDriverOnErrorJustComplete(),
            responseTriggers: [
                self.leftLever.rx.tap
                    .mapToVoid()
                    .asDriverOnErrorJustComplete(),
                self.rightLever.rx.tap
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            ]
        )

        guard let presenter = presenter else { return }

        let output = presenter.transform(input: input)

        Observable.merge(output.reinforcement)
            .subscribe(onNext: { _ in
                print("Reinforcement!!")
            })
            .disposed(by: self.disposeBag)
    }
}
