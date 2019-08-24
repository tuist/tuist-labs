import XCTest
@testable import TuistModelTests

XCTMain([
    testCase(OrderedRecursiveGraphReducerTests.allTests),
    testCase(RecursiveGraphReducerTests.allTests)
])