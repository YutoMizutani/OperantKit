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

        let input = SessionPresenter.Input(
            startTrigger: startTrigger,
            pauseTrigger: pauseTrigger,
            resumeTrigger: resumeTrigger,
            endTrigger: endTrigger,
            responseTriggers: [
                chamberView.leftLever.rx.tap
                    .mapToVoid()
                    .asDriverOnErrorJustComplete(),
                chamberView.rightLever.rx.tap
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            ]
        )

        guard let presenter = presenter else { return }

        let output = presenter.transform(input: input)

        Driver.merge(output.start, output.resume)
            .map { _ in UIColor.ratChamber.light.on }
            .asDriver()
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        Driver.merge(output.pause, output.end)
            .map { _ in UIColor.ratChamber.light.off }
            .asDriver()
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        Observable.merge(output.reinforcement + [output.pause.asObservable()])
            .map { _ in UIColor.ratChamber.light.off }
            .asDriverOnErrorJustComplete()
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        Observable.merge(output.reinforcement)
            .subscribe(onNext: { _ in
                print("Reinforcement!!")
            })
            .disposed(by: disposeBag)
    }
}
