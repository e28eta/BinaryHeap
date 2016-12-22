import XCTest
@testable import BinaryHeap

class Foo: Comparable, CustomStringConvertible {
    let bar: Int

    init(_ bar: Int) {
        self.bar = bar
    }

    static func <(_ lhs: Foo, _ rhs: Foo) -> Bool {
        return lhs.bar < rhs.bar
    }

    static func ==(_ lhs: Foo, _ rhs: Foo) -> Bool {
        return lhs.bar == rhs.bar
    }

    var description: String {
        return String(bar)
    }
}

class BinaryHeapTests: XCTestCase {
    func testPopInSortedOrder() {
        let h = BinaryHeap<Foo>()

        let foos = [Foo(10), Foo(2), Foo(8), Foo(5)]
        for foo in foos {
            h.push(foo)
        }

        let sortedFoos = foos.sorted()

        for foo in sortedFoos {
            XCTAssertEqual(foo, h.pop(), "Heap should pop Foos in sorted order")
        }
    }


    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testPopInSortedOrder", testPopInSortedOrder),
        ]
    }
}
