final class UICardViewReusePool {
    
    private var pool = Set<UICardView>()
    
    func enqueue(_ view: UICardView) {
        pool.insert(view)
    }
    
    func dequeue() -> UICardView? {
        return pool.popFirst()
    }
}
