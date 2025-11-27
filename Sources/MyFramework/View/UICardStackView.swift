import UIKit

open class UICardStackView: UIView {
    
    public var config: UICardStackViewConfig = UICardStackViewConfig()
    public weak var dataSource: UICardStackViewDataSource?
    public weak var delegate: UICardStackViewDelegate?
    
    private let reusePool = UICardViewReusePool()
    private var currentIndex = 0
    private var visibleCards: [UICardView] = []
    private var totalCount: Int { dataSource?.cardStackView(in: self) ?? 0 }
    
    public func reloadData() {
        visibleCards.forEach {
            $0.removeFromSuperview()
            $0.prepareForReuse()
            reusePool.enqueue($0)
        }
        visibleCards.removeAll()
        currentIndex = 0
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
        guard totalCount > 0 else { return }
        
        let visibleCardsNum = config.endless ? config.maxVisibleCards : min(config.maxVisibleCards, totalCount)
        
        for i in 0..<visibleCardsNum {
            let idx = (currentIndex + i) % totalCount
            let card = createCard(at: idx)
            visibleCards.append(card)
            addSubview(card)
        }

        layoutCards()
    }
    
    private func createCard(at index: Int) -> UICardView {
        let cardView = dataSource?.cardStackView(self, viewForCardAt: index) ?? dequeueReusableCard()
        cardView.frame = self.bounds
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.swipeThreshold = config.swipeThreshold
        cardView.rotationMax = config.rotationMax
        cardView.animationDuration = config.animationDuration
        cardView.opacityRate = config.opacityRate
        setupCallbacks(for: cardView)
        return cardView
    }
    
    private func layoutCards(animated: Bool = false) {
        for (i, card) in visibleCards.enumerated() {
            card.isUserInteractionEnabled = (i == 0)
            
            let level = CGFloat(i)
            let scale = 1 - level * config.scaleFactor
            let xScale = level * config.xCardSpacing
            let yScale = level * config.yCardSpacing
            
            let targetTransform = CGAffineTransform(translationX: xScale, y: yScale).scaledBy(x: scale, y: scale)
            
            if animated && i != visibleCards.count - 1 {
                UIView.animate(withDuration: config.animationDuration) {
                    card.transform = targetTransform
                }
            } else {
                card.transform = targetTransform
            }
            
            sendSubviewToBack(card)
        }
    }
    
    private func setupCallbacks(for card: UICardView) {
        card.onDrag = { [weak self] xOffset in
            guard let self else { return }
            delegate?.cardStackView(self, didDragCardAt: self.currentIndex, translation: xOffset)
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
        
        delegate?.cardStackView(self, didSwipeCardAt: currentIndex, direction: direction)
        
        guard let top = visibleCards.first else { return }
        top.removeFromSuperview()
        visibleCards.removeFirst()
        reusePool.enqueue(top)
        
        currentIndex = config.endless ? (currentIndex + 1) % totalCount : currentIndex + 1
        guard currentIndex < totalCount else {
            delegate?.cardStackViewDidRunOutOfCards(self)
            return
        }
        
        let nextIndexRaw = currentIndex + config.maxVisibleCards - 1
        let nextIndex = config.endless ? nextIndexRaw % totalCount : nextIndexRaw
        
        guard nextIndex < totalCount else { return }
        
        let next = createCard(at: nextIndex)
        visibleCards.append(next)
        addSubview(next)
        
        layoutCards(animated: true)
    }
}
