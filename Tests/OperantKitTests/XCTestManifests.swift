import XCTest

#if !os(iOS) && !os(macOS) && !os(tvOS) && !os(watchOS)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(OperantKitTests.allTests),
        testCase(FleshlerHoffmanTests.allTests),
        testCase(ScheduleTypeTests.allTests),
        testCase(ExtinctionScheduleTests.allTests),
        testCase(FixedIntervalScheduleTests.allTests),
        testCase(FixedRatioScheduleTests.allTests),
        testCase(RandomIntervalScheduleTests.allTests),
        testCase(VariablIntervaleScheduleTests.allTests),
        testCase(VariableRatioScheduleTests.allTests),
    ]
}
#endif
