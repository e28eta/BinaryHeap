import Foundation


/*:
 Wrapper around CFBinaryHeap
 */
public class BinaryHeap<Element: Comparable & AnyObject & CustomStringConvertible> {
    typealias CompareElementFunction = (UnsafeRawPointer, UnsafeRawPointer) -> CFComparisonResult

    let heap: CFBinaryHeap

    public init() {
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

                let contextCompare = Unmanaged<AnyObject>.fromOpaque(contextPtr).takeUnretainedValue() as! CompareElementFunction
                return contextCompare(obj1, obj2)
        }
        )
        var context = CFBinaryHeapCompareContext(
            version: 0,
            info: Unmanaged.passRetained(BinaryHeap<Element>._compare as AnyObject).toOpaque(),
            retain: {
                UnsafeRawPointer(Unmanaged<AnyObject>.fromOpaque($0!).retain().toOpaque())
        }, release: {
            Unmanaged<AnyObject>.fromOpaque($0!).release()
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

    static func _compare(p1: UnsafeRawPointer, p2: UnsafeRawPointer) -> CFComparisonResult {
        let o1 = Unmanaged<Element>.fromOpaque(p1).takeUnretainedValue()
        let o2 = Unmanaged<Element>.fromOpaque(p2).takeUnretainedValue()

        if o1 < o2 {
            return .compareLessThan
        } else if o1 > o2 {
            return .compareGreaterThan
        } else {
            return .compareEqualTo
        }
    }


}


