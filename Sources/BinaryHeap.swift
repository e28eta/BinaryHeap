import Foundation

/*:
 Wrapper around CFBinaryHeap
 */
public class BinaryHeap<Element: AnyObject> {
    let heap: CFBinaryHeap

    public convenience init(by areInIncreasingOrder: @escaping ((Element, Element) -> Bool)) {
        self.init(CompareBox(by: areInIncreasingOrder))
    }

    fileprivate init(_ compareBox: CompareBox) {
        var callbacks = CFBinaryHeapCallBacks(
            version: 0,
            retain: { _, obj in
                guard let obj = obj else { return nil }
                return UnsafeRawPointer(Unmanaged<AnyObject>.fromOpaque(obj).retain().toOpaque())
        },
            release: { _, obj in
                guard let obj = obj else { return }
                Unmanaged<AnyObject>.fromOpaque(obj).release()
        },
            copyDescription: { obj in
                guard let obj = obj else { return nil }
                let o = Unmanaged<AnyObject>.fromOpaque(obj).takeUnretainedValue()
                return Unmanaged.passRetained(String(describing: o) as CFString)
        },
            compare: { obj1, obj2, contextPtr in
                guard let obj1 = obj1, let obj2 = obj2, let contextPtr = contextPtr else {
                    fatalError("CFBinaryHeap called compare with a nil parameter")
                }

                let compareBox = Unmanaged<CompareBox>.fromOpaque(contextPtr).takeUnretainedValue()
                return compareBox.compare(obj1, obj2)
        }
        )

        var context = CFBinaryHeapCompareContext(
            version: 0,
            info: Unmanaged.passRetained(compareBox).toOpaque(),
            retain: {
                UnsafeRawPointer(Unmanaged<CompareBox>.fromOpaque($0!).retain().toOpaque())
        }, release: {
            Unmanaged<CompareBox>.fromOpaque($0!).release()
        }, copyDescription: nil)


        heap = CFBinaryHeapCreate(nil, 0, &callbacks, &context)
    }

    public func push(_ e: Element) {
        let pointer = Unmanaged<Element>.passRetained(e).toOpaque()

        CFBinaryHeapAddValue(heap, pointer)
    }

    public func pop() -> Element? {
        guard let result = CFBinaryHeapGetMinimum(heap) else {
            return nil
        }

        CFBinaryHeapRemoveMinimumValue(heap)

        return Unmanaged<Element>.fromOpaque(result).takeUnretainedValue()
    }
}

extension BinaryHeap where Element: Comparable {
    public convenience init(ascending: Bool = true) {
        if ascending {
            self.init(CompareBox(by: { (o1: Element, o2: Element) -> Bool in o1 < o2 }))
        } else {
            self.init(CompareBox(by: { (o1: Element, o2: Element) -> Bool in o2 < o1 }))
        }
    }
}

fileprivate class CompareBox {
    let compare: ((UnsafeRawPointer, UnsafeRawPointer) -> CFComparisonResult)

    init<T: AnyObject>(by areInIncreasingOrder: @escaping ((T, T) -> Bool)) {
        self.compare = { (p1: UnsafeRawPointer, p2: UnsafeRawPointer) -> CFComparisonResult in
            let o1 = Unmanaged<T>.fromOpaque(p1).takeUnretainedValue()
            let o2 = Unmanaged<T>.fromOpaque(p2).takeUnretainedValue()

            if areInIncreasingOrder(o1, o2) {
                return .compareLessThan
            } else if areInIncreasingOrder(o2, o1) {
                return .compareGreaterThan
            } else {
                return .compareEqualTo
            }
        }
    }
}

