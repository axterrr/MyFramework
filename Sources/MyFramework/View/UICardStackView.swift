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
        
        delegate?.cardStackViewDidReloadData(self)
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
            
            let isLastVisibleCard = (i == visibleCards.count - 1)
            let isNewCard = isLastVisibleCard && (visibleCards.count == config.maxVisibleCards)
                        
            if animated && !isNewCard {
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
        card.onBeginDrag = { [weak self] in
            guard let self else { return }
            delegate?.cardStackView(self, didBeginDraggingCardAt: currentIndex)
        }
        
        card.onDrag = { [weak self] translation in
            guard let self else { return }
            delegate?.cardStackView(self, didDragCardAt: currentIndex, translation: translation)
        }
        
        card.onCancellSwipe = { [weak self] in
            guard let self else { return }
            delegate?.cardStackView(self, didCancelSwipeCardAt: currentIndex)
        }
        
        card.onDidTap = { [weak self] in
            guard let self else { return }
            delegate?.cardStackView(self, didTapCardAt: currentIndex)
        }
        
        card.onWillSwipe = { [weak self] direction in
            self?.handleWillSwipe(direction: direction)
        }
        
        card.onDidSwipe = { [weak self] direction in
            self?.handleDidSwipe(card, direction: direction)
        }
    }
    
    private func handleWillSwipe(direction: UICardViewSwipeDirection) {
        delegate?.cardStackView(self, willSwipeCardAt: currentIndex, direction: direction)
        
        visibleCards.removeFirst()
        
        let nextIndexRaw = currentIndex + config.maxVisibleCards
        let nextIndex = config.endless ? nextIndexRaw % totalCount : nextIndexRaw
        
        if nextIndex < totalCount {
            let next = createCard(at: nextIndex)
            visibleCards.append(next)
            insertSubview(next, at: 0)
        }
        
        layoutCards(animated: true)
    }
    
    private func handleDidSwipe(_ card: UICardView, direction: UICardViewSwipeDirection) {
        delegate?.cardStackView(self, didSwipeCardAt: currentIndex, direction: direction)
        
        card.removeFromSuperview()
        card.prepareForReuse()
        reusePool.enqueue(card)
        
        currentIndex = config.endless ? (currentIndex + 1) % totalCount : currentIndex + 1
        if currentIndex == totalCount {
            delegate?.cardStackViewDidRunOutOfCards(self)
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        for card in visibleCards.dropFirst() {
            let savedTransform = card.transform
            card.transform = .identity
            card.frame = bounds
            card.transform = savedTransform
        }
    }
}
