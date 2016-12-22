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
    func createFoos(ascending: Bool = true) -> (BinaryHeap<Foo>, [Foo]) {
        let heap = BinaryHeap<Foo>(ascending: ascending)

        let foos = [Foo(10), Foo(2), Foo(8), Foo(5), Foo(7)]
        for foo in foos {
            heap.push(foo)
        }

        return (heap, foos.sorted())
    }

    func testPopInSortedOrder() {
        let (heap, foos) = createFoos()

        XCTAssertEqual(foos[0], heap.peek(), "peek should result in first element")
        XCTAssertEqual(foos[0], heap.peek(), "peek should result in first element")

        for foo in foos {
            XCTAssertEqual(foo, heap.pop(), "Heap should pop Foos in sorted order")
        }
        XCTAssertNil(heap.pop(), "Empty heap pops() nil")
    }

    func testReverseOrder() {
        let (heap, foos) = createFoos(ascending: false)
        let reverseFoos = foos.reversed()

        XCTAssertEqual(heap.pop(), reverseFoos.first, "Heap should pop foos in reverse sorted order")
        XCTAssertEqual(heap.pop(), reverseFoos.dropFirst().first, "Heap should pop foos in reverse sorted order")
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
        XCTAssertEqual(BinaryHeap<Foo>().count(), 0, "Empty heap has 0 count")

        let (heap, foos) = createFoos()

        XCTAssertEqual(heap.count(), foos.count)
        let _ = heap.pop()
        XCTAssertEqual(heap.count(), foos.count - 1)
    }

    func testContains() {
        let (heap, foos) = createFoos()

        for foo in foos {
            XCTAssertTrue(heap.contains(foo))
        }
        XCTAssertFalse(heap.contains(Foo(-1)))
    }

    func testRemoveAllValues() {
        let (heap, foos) = createFoos()

        XCTAssertEqual(heap.count(), foos.count)
        XCTAssertGreaterThan(heap.count(), 0)

        heap.removeAllObjects()
        XCTAssertEqual(heap.count(), 0)
        XCTAssertNil(heap.peek())
        XCTAssertNil(heap.pop())
    }


    static var allTests : [(String, (BinaryHeapTests) -> () throws -> Void)] {
        return [
            ("testPopInSortedOrder", testPopInSortedOrder),
            ("testReverseOrder", testReverseOrder),
            ("testNonComparable", testNonComparable),
            ("testNonObject", testNonObject),
            ("testCount", testCount),
            ("testContains", testContains),
            ("testRemoveAllValues", testRemoveAllValues),
        ]
    }
}
