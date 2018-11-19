import RxSwift
import XCTest
@testable import OperantKit

final class OperantKitTests: XCTestCase {
    /// Tolerance delay (ms); Added for low spec test from CI.
    let toleranceDelay: Int = 100

    #if os(macOS)
    /// Correct time test
    func testWhileLoopTimer() {
        let targetMilliseconds: Int = Int(arc4random() % 500) + 100
        let timer = WhileLoopTimerUseCase()
        let disposeBag = DisposeBag()
        Observable<Void>.just(())
            .flatMap { timer.start() }
            .subscribe()
            .disposed(by: disposeBag)
        usleep(UInt32(targetMilliseconds) * 1000)
        Observable<Void>.just(())
            .flatMap { timer.finish() }
            .subscribe(onNext: { [unowned self] in
                XCTAssertGreaterThanOrEqual($0, targetMilliseconds - self.toleranceDelay)
            })
            .disposed(by: disposeBag)
    }
    #endif

    #if os(macOS) && canImport(QuartzCore)
    /// Correct time test
    func testCVDisplayLinkTimer() {
        let targetMilliseconds: Int = Int(arc4random() % 500) + 100
        let timer = CVDisplayLinkTimerUseCase()
        let disposeBag = DisposeBag()
        Observable<Void>.just(())
            .flatMap { timer.start() }
            .subscribe()
            .disposed(by: disposeBag)
        usleep(UInt32(targetMilliseconds) * 1000)
        Observable<Void>.just(())
            .flatMap { timer.finish() }
            .subscribe(onNext: { [unowned self] in
                XCTAssertGreaterThanOrEqual($0, targetMilliseconds - self.toleranceDelay)
            })
            .disposed(by: disposeBag)
    }
    #endif
}
