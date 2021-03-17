// 这是一个去重的操作, 遍历一次, 然后返回一个新的数组.
// 按照 Item 第一次出现的顺序进行排序.
extension Sequence where Element: Hashable {
    /// Returns an array with only the unique elements of this sequence, in the
    /// order of the first occurrence of each unique element.
    ///
    ///     let animals = ["dog", "pig", "cat", "ox", "dog", "cat"]
    ///     let uniqued = animals.uniqued()
    ///     print(uniqued)
    ///     // Prints '["dog", "pig", "cat", "ox"]'
    ///
    /// - Returns: An array with only the unique elements of this sequence.
    ///  .
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable
    public func uniqued() -> [Element] {
        uniqued(on: { $0 })
    }
}

// projection 规划, 表示变化.
extension Sequence {
    /// Returns an array with the unique elements of this sequence (as determined
    /// by the given projection), in the order of the first occurrence of each
    /// unique element.
    ///
    /// This example finds the elements of the `animals` array with unique
    /// first characters:
    ///
    ///     let animals = ["dog", "pig", "cat", "ox", "cow", "owl"]
    ///     let uniqued = animals.uniqued(on: {$0.first})
    ///     print(uniqued)
    ///     // Prints '["dog", "pig", "cat", "ox"]'
    ///
    /// - Parameter projection: A closure that transforms an element into the
    ///   value to use for uniqueness. If `projection` returns the same value
    ///   for two different elements, the second element will be excluded
    ///   from the resulting array.
    ///
    /// - Returns: An array with only the unique elements of this sequence, as
    ///   determined by the result of `projection` for each element.
    ///
    /// - Complexity: O(*n*), where *n* is the length of the sequence.
    @inlinable
    public func uniqued<Subject: Hashable>(
        on projection: (Element) throws -> Subject
    ) rethrows -> [Element] {
        // 实际上, 做过滤的是 projection 的结果, 而返回的, 还是 Item. 而不是 projection 组成的数组.
        var seen: Set<Subject> = []
        var result: [Element] = []
        for element in self {
            // 这里, seen.insert 返回一个 tuple, 里面 inserted 这个值, 作为是否插入的标志.
            if seen.insert(try projection(element)).inserted {
                result.append(element)
            }
        }
        return result
    }
}

