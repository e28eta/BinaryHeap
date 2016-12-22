import XCTest
@testable import BinaryHeap

class Foo: Comparable {
    let value: Int

    init(_ value: Int) {
        self.value = value
    }

    static func <(_ lhs: Foo, _ rhs: Foo) -> Bool {
        return lhs.value < rhs.value
    }

    static func ==(_ lhs: Foo, _ rhs: Foo) -> Bool {
        return lhs.value == rhs.value
    }
}

class Bar {
    let value: Int

    init(_ value: Int) {
        self.value = value
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
        let heap = BinaryHeap<Foo>(ascending: false)

        let foos = [Foo(10), Foo(1)]
        for foo in foos {
            heap.push(foo)
        }

        XCTAssertEqual(heap.pop(), foos[0], "Heap should pop foos in reverse sorted order")
        XCTAssertEqual(heap.pop(), foos[1], "Heap should pop foos in reverse sorted order")
        XCTAssertNil(heap.pop(), "Empty heap pops() nil")
    }

    func testNonComparable() {
        let heap = BinaryHeap<Bar>() { $0.value < $1.value }

        let bars = [Bar(1), Bar(10), Bar(3)]
        for bar in bars {
            heap.push(bar)
        }

        XCTAssertEqual(heap.pop()?.value, bars[0].value,
                       "Heap should work with non-Comparable objects if comparison closure provided")
    }




    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testPopInSortedOrder", testPopInSortedOrder),
            ("testReverseOrder", testReverseOrder),
            ("testNonComparable", testNonComparable)
        ]
    }
}
