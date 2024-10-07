extension Collection<String> {
    public func removingEmpty() -> [Element] {
        filter { !$0.isEmpty }
    }
}
