// Cycle 的数据, 仅仅是记录一下原有的 Collection 而已
// 但是它在表现上, 要是一个循环取值的 Collection, 由于 Sequence 的取值, 是在 Iterator 这个类上表现的. 所以, 重点是 Iter 的实现.

// 我们自己想要实现这样的一个 Colleciton, 也是很简单的.
// 专门定义出一个类型来, 可以让这段代码很好的进行复用.
public struct Cycle<Base: Collection> {
    public let base: Base
    internal init(base: Base) {
        self.base = base
    }
}

// 其实这里, 就和我们自己写的循环没有太大的区别
extension Cycle: Sequence {
    /// The iterator for a `Cycle` sequence.
    // Iterator 是内部类型, 不需要暴露出去.
    public struct Iterator: IteratorProtocol {
        @usableFromInline
        let base: Base
        
        @usableFromInline
        var current: Base.Index
        
        @usableFromInline
        internal init(base: Base) {
            self.base = base
            self.current = base.startIndex
        }
        
        @inlinable
        public mutating func next() -> Base.Element? {
            guard !base.isEmpty else { return nil }
            
            if current == base.endIndex {
                current = base.startIndex
            }
            
            defer { base.formIndex(after: &current) }
            return base[current]
        }
    }
    
    @inlinable
    public func makeIterator() -> Iterator {
        Iterator(base: base)
    }
}

extension Cycle: LazySequenceProtocol where Base: LazySequenceProtocol {}

//===----------------------------------------------------------------------===//
// cycled()
//===----------------------------------------------------------------------===//

extension Collection {
    public func cycled() -> Cycle<Self> {
        Cycle(base: self)
    }
    
    // 这里, 没有说在里面存储一个 times 的值, 而是使用了其他已经实现好的抽象. 
    public func cycled(times: Int) -> FlattenSequence<Repeated<Self>> {
        repeatElement(self, count: times).joined()
    }
}
