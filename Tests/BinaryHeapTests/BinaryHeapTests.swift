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

struct Baz {
    let value: Int
}

class BinaryHeapTests: XCTestCase {
    func testPopInSortedOrder() {
        let h = BinaryHeap<Foo>()

        let foos = [Foo(10), Foo(2), Foo(8), Foo(5)]
        for foo in foos {
            h.push(foo)
        }

        let sortedFoos = foos.sorted()

        XCTAssertEqual(sortedFoos[0], h.peek(), "peek should result in first element")
        XCTAssertEqual(sortedFoos[0], h.peek(), "peek should result in first element")

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

    func testNonObject() {
        let heap = BinaryHeap<Baz>() { $0.value < $1.value }

        let bazs = [Baz(value: 15), Baz(value: 10)]
        for baz in bazs {
            heap.push(baz)
        }

        XCTAssertEqual(heap.pop()?.value, 10)
    }

    func testCount() {
        let heap = BinaryHeap<Foo>()

        XCTAssertEqual(heap.count(), 0)

        let foos = [Foo(10), Foo(8), Foo(9), Foo(0)]
        for foo in foos {
            heap.push(foo)
        }

        XCTAssertEqual(heap.count(), 4)
        let _ = heap.pop()
        XCTAssertEqual(heap.count(), 3)
    }


    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testPopInSortedOrder", testPopInSortedOrder),
            ("testReverseOrder", testReverseOrder),
            ("testNonComparable", testNonComparable),
            ("testNonObject", testNonObject),
            ("testCount", testCount),
        ]
    }
}
