import XCTest
@testable import BinaryHeap

class BinaryHeapTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(BinaryHeap().text, "Hello, World!")
    }


    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testExample", testExample),
        ]
    }
}
