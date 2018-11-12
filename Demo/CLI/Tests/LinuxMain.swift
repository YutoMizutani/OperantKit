import XCTest

import CLITests

var tests = [XCTestCaseEntry]()
tests += CLITests.allTests()
XCTMain(tests)