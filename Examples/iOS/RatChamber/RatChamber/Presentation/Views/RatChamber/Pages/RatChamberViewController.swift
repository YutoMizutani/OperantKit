//
//  RatChamberViewController.swift
//  RatChamber
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
    private var config: RatChamberConfig = RatChamberConfig()
    private let disposeBag = DisposeBag()

    func inject(presenter: PresenterType, config: RatChamberConfig = RatChamberConfig()) {
        self.presenter = presenter
        self.config = config
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.chamberView.leftLever.isEnabled = self.config.leverEnabled.left
        self.chamberView.rightLever.isEnabled = self.config.leverEnabled.right

        let input = SessionPresenter.Input(
            startTrigger: startTrigger,
            pauseTrigger: pauseTrigger,
            resumeTrigger: resumeTrigger,
            endTrigger: endTrigger,
            responseTriggers: [
                chamberView.leftLever.rx.tap
                    .filter { [unowned self] in self.chamberView.leftLever.isSelected }
                    .mapToVoid()
                    .asDriverOnErrorJustComplete(),
                chamberView.rightLever.rx.tap
                    .filter { [unowned self] in self.chamberView.rightLever.isSelected }
                    .mapToVoid()
                    .asDriverOnErrorJustComplete()
            ]
        )

        guard let presenter = presenter else { return }

        let output = presenter.transform(input: input)
        let reinforcementOnEvent = Driver.merge(output.reinforcements.map { $0.on })
        let reinforcementOffEvent = Driver.merge(output.reinforcements.map { $0.off })

        let workingDriver = Driver.merge(
            output.start,
            output.resume,
            reinforcementOffEvent)

        workingDriver
            .map { [unowned self] _ in self.config.lightColor.left.on }
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        workingDriver
            .map { [unowned self] _ in self.config.lightColor.right.on }
            .drive(chamberView.rightLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        let pauseDriver = Driver.merge(
            output.pause,
            output.end,
            reinforcementOnEvent
        )

        pauseDriver
            .map { [unowned self] _ in self.config.lightColor.left.off }
            .drive(chamberView.leftLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        pauseDriver
            .map { [unowned self] _ in self.config.lightColor.right.off }
            .drive(chamberView.rightLight.rx.backgroundColor)
            .disposed(by: disposeBag)

        let reinforcementDriver = Driver.merge(
            reinforcementOnEvent.map { false },
            reinforcementOffEvent.map { true }
        )

        reinforcementDriver
            .drive(chamberView.leftLever.rx.isSelected)
            .disposed(by: disposeBag)

        reinforcementDriver
            .drive(chamberView.rightLever.rx.isSelected)
            .disposed(by: disposeBag)

        let feederSoundPlayer = RatChamberSound.shared.feeder.operatingSound
        feederSoundPlayer?.prepareToPlay()
        reinforcementOnEvent
            .asObservable()
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                feederSoundPlayer?.currentTime = 0
                feederSoundPlayer?.play()
                RatChamberPelletButton.create(self, base: self.chamberView.baseView) { [weak self] in
                    guard let self = self else { return }
                    $0.animation(base: self.chamberView)
                }
            })
            .disposed(by: disposeBag)
    }
}
