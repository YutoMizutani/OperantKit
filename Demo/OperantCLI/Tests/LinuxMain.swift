import XCTest

import OperantCLITests

var tests = [XCTestCaseEntry]()
tests += OperantCLITests.allTests()
XCTMain(tests)