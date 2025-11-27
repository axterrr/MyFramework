import UIKit

open class UICardStackView: UIView {
    
    public var config: UICardStackViewConfig = UICardStackViewConfig()
    public weak var dataSource: UICardStackViewDataSource?
    public weak var delegate: UICardStackViewDelegate?
    
    private let reusePool = UICardViewReusePool()
    private var currentIndex = 0
    private var topCard: UICardView?
    private var nextCard: UICardView?
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        currentIndex = 0
        topCard = nil
        nextCard = nil
        loadCards()
    }
    
    public func dequeueReusableCard() -> UICardView {
        if let card = reusePool.dequeue() {
            card.prepareForReuse()
            return card
        }
        return UICardView()
    }
    
    private func loadCards() {
        guard let dataSource = dataSource else { return }
        let total = dataSource.cardStackView(in: self)
        guard total > 0 else { return }
        
        if total > 1 || config.endless {
            let nextIndex = (currentIndex + 1) % total
            let next = createCard(at: nextIndex)
            addSubview(next)
            nextCard = next
        }
        
        let top = createCard(at: currentIndex)
        addSubview(top)
        topCard = top
    }
    
    private func createCard(at index: Int) -> UICardView {
        let cardView = dataSource?.cardStackView(self, viewForCardAt: index) ?? dequeueReusableCard()
        
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.swipeThreshold = config.swipeThreshold
        cardView.rotationMax = config.rotationMax
        cardView.animationDuration = config.animationDuration
        setupCallbacks(for: cardView)
        
        return cardView
    }
    
    private func setupCallbacks(for card: UICardView) {
        card.onDrag = { [weak self] xOffset in
            guard let self = self, let topCard = self.topCard else { return }
            
            let progress = min(abs(xOffset) / (self.config.swipeThreshold * 2), 1.0)
            topCard.alpha = 1.0 - (config.oparcityRate * progress)
            
            if let nextCard = self.nextCard {
                let scaleDiff = self.config.scaleFactor
                let baseScale = 1.0 - scaleDiff
                let currentScale = baseScale + (scaleDiff * progress)
                let translationY = 15 - (15 * progress)
                
                nextCard.transform = CGAffineTransform(scaleX: currentScale, y: currentScale)
                    .concatenating(CGAffineTransform(translationX: 0, y: translationY))
            }
        }
        
        card.onWillSwipe = { [weak self] direction in
            guard let self = self, let nextCard = self.nextCard else { return }
            UIView.animate(withDuration: self.config.animationDuration) {
                nextCard.transform = .identity
            }
        }
        
        card.onDidSwipe = { [weak self] direction in
            self?.handleSwipeCompletion(direction: direction)
        }
        
        card.onDidTap = { [weak self] in
            guard let self else { return }
            self.delegate?.cardStackView(self, didTapCardAt: self.currentIndex)
        }
    }
    
    private func handleSwipeCompletion(direction: UICardViewSwipeDirection) {
        guard let dataSource = dataSource else { return }
        let total = dataSource.cardStackView(in: self)
        
        delegate?.cardStackView(self, didSwipeCardAt: currentIndex, direction: direction)
        
        guard let oldTop = topCard else { return }
        oldTop.removeFromSuperview()
        reusePool.enqueue(oldTop)
        topCard = nextCard
        
        currentIndex = config.endless ? (currentIndex + 1) % total : currentIndex + 1
        guard currentIndex < total else {
            delegate?.cardStackViewDidRunOutOfCards(self)
            return
        }
        
        let nextIndex = config.endless ? (currentIndex + 1) % total : currentIndex + 1
        guard nextIndex < total else {
            nextCard = nil
            return
        }
        
        let newNext = createCard(at: nextIndex)
        insertSubview(newNext, at: 0)
        nextCard = newNext
    }
}
