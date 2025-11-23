import UIKit

public class UICardStackView: UIView {
    
    public var config: UICardStackViewConfig = UICardStackViewConfig()
    public weak var dataSource: UICardStackViewDataSource?
    public weak var delegate: UICardStackViewDelegate?
    
    private var currentIndex = 0
    private var topCard: UICardView?
    private var nextCard: UICardView?
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        currentIndex = 0
        loadCards()
    }
    
    private func loadCards() {
        guard let dataSource = dataSource else { return }
        let total = dataSource.cardStackView(in: self)
        
        guard total > 0 else { return }
        
        if total > 1 {
            let nextIndex = (currentIndex + 1) % total
            let next = createCard(at: nextIndex)
            addSubview(next)
            applyNextCardTransform(next)
            nextCard = next
        }
        
        let top = createCard(at: currentIndex)
        addSubview(top)
        topCard = top
    }
    
    private func createCard(at index: Int) -> UICardView {
        guard let frontView = dataSource?.cardStackView(self, viewForCardAt: index) else { return UICardView() }
        let cardView = UICardView(frame: bounds)
        cardView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardView.frontView = frontView
        
        if let backView = dataSource?.cardStackView(self, backViewForCardAt: index) {
            cardView.backView = backView
        }
        
        setupCallbacks(for: cardView)
        return cardView
    }
    
    private func setupCallbacks(for card: UICardView) {
        card.onDrag = { [weak self] xOffset in
            guard let self = self, let nextCard = self.nextCard, let topCard = self.topCard else { return }
            let progress = min(abs(xOffset) / 300, 1.0)
            let scale = 0.9 + (0.1 * progress)
            let translationY = 15 - (15 * progress)
            nextCard.transform = CGAffineTransform(scaleX: scale, y: scale)
                .concatenating(CGAffineTransform(translationX: 0, y: translationY))
            topCard.alpha = 1.0 - (0.3 * progress)
        }
        
        card.onSwipeEnd = { [weak self] direction in
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
        
        guard let oldTop = topCard, let newTop = nextCard else { return }
        oldTop.removeFromSuperview()
        currentIndex = (currentIndex + 1) % total
        topCard = newTop
        
        UIView.animate(withDuration: 0.2) {
            newTop.transform = .identity
        }
        
        let nextIndex = (currentIndex + 1) % total
        let newNext = createCard(at: nextIndex)
        insertSubview(newNext, at: 0)
        applyNextCardTransform(newNext)
        nextCard = newNext
    }
    
    private func applyNextCardTransform(_ card: UIView) {
        let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let translate = CGAffineTransform(translationX: 0, y: 15)
        card.transform = scale.concatenating(translate)
    }
}
