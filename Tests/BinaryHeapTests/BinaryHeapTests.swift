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
        XCTAssertNil(h.pop(), "Empty heap pops() nil")
    }

    func testReverseOrder() {
        let heap = BinaryHeap<Foo>() {
            if $1 < $0 {
                return .compareLessThan
            } else if $1 > $0 {
                return .compareGreaterThan
            } else {
                return .compareEqualTo
            }
        }

        let foos = [Foo(10), Foo(1)]
        for foo in foos {
            heap.push(foo)
        }

        XCTAssertEqual(heap.pop(), foos[0], "Heap should pop foos in reverse sorted order")
        XCTAssertEqual(heap.pop(), foos[1], "Heap should pop foos in reverse sorted order")
        XCTAssertNil(heap.pop(), "Empty heap pops() nil")
    }




    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testPopInSortedOrder", testPopInSortedOrder),
        ]
    }
}
