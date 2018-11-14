import XCTest

import sandboxTests

var tests = [XCTestCaseEntry]()
tests += sandboxTests.allTests()
XCTMain(tests)