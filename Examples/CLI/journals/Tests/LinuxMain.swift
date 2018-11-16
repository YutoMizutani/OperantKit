import XCTest

import journalsTests

var tests = [XCTestCaseEntry]()
tests += journalsTests.allTests()
XCTMain(tests)