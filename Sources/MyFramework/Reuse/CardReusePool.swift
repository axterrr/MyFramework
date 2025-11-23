final class CardReusePool {
    
    private var pool: [UICardView] = []

    func enqueue(_ view: UICardView) {
        pool.append(view)
    }

    func dequeue() -> UICardView? {
        return pool.popLast()
    }
}
