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

        let reinforcementOnEvent = Observable.merge(output.reinforcement)
            .share(replay: 1)

        let iri: RxTimeInterval = 5
        let reinforcementOffEvent = reinforcementOnEvent
            .delay(iri, scheduler: SerialDispatchQueueScheduler(qos: .default))
            .share(replay: 1)

        reinforcementOffEvent
            .map { true }
            .asDriverOnErrorJustComplete()
            .drive(chamberView.leftLever.rx.isSelected)
            .disposed(by: disposeBag)

        reinforcementOffEvent
            .map { _ in UIColor.ratChamber.light.on }
            .asDriverOnErrorJustComplete()
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        reinforcementOnEvent
            .map { false }
            .asDriverOnErrorJustComplete()
            .drive(chamberView.leftLever.rx.isSelected)
            .disposed(by: disposeBag)

        let feederSoundPlayer = RatChamberSound.shared.feeder.operatingSound
        feederSoundPlayer?.prepareToPlay()
        reinforcementOnEvent
            .subscribe(onNext: { _ in
                feederSoundPlayer?.currentTime = 0
                feederSoundPlayer?.play()

                print("Reinforcement!!")
            })
            .disposed(by: disposeBag)
    }
}
