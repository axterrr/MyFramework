import UIKit

public class UICardStackView: UIView {
    
    public weak var dataSource: UICardStackDataSource?
    public weak var delegate: UICardStackDelegate?
    
    private var currentIndex = 0
    
    private var topCard: UICardView?
    private var nextCard: UICardView?
    //private var backCard: UICardView?
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        currentIndex = 0
        initCards()
    }
    
    private func initCards() {
        guard let dataSource = dataSource else { return }
        let total = dataSource.numberOfCards(in: self)
        
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
        guard let content = dataSource?.cardStack(self, viewForCardAt: index) else { return UICardView() }
        let container = UICardView(frame: bounds)
        container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        container.frontContainer.addSubview(content)
        content.frame = container.frontContainer.bounds
        content.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        setupCallbacks(for: container)
        self.addSubview(container)
        return container
    }
    
    private func setupCallbacks(for card: UICardView) {
        card.onDragRight = { [weak self] xOffset in
            guard let self = self, let nextCard = self.nextCard, let topCard = self.topCard else { return }
            let progress = min(abs(xOffset) / 300, 1.0)
            let scale = 0.9 + (0.1 * progress)
            let translationY = 15 - (15 * progress)
            nextCard.transform = CGAffineTransform(scaleX: scale, y: scale)
                .concatenating(CGAffineTransform(translationX: 0, y: translationY))
            topCard.alpha = 1 - (0.4 * progress)
        }
        
        card.onDragLeft = { [weak self] xOffset in
            self?.handleLeftDrag(xOffset: xOffset)
        }
        
        card.onSwipeEnd = { [weak self] direction in
            self?.handleSwipeCompletion(direction: direction)
        }
    }
    
    private func handleLeftDrag(xOffset: CGFloat) {
    }
    
    private func handleSwipeCompletion(direction: SwipeDirection) {
        guard let dataSource = dataSource else { return }
        let total = dataSource.numberOfCards(in: self)
        
        delegate?.cardStack(self, didSwipeCardAt: currentIndex, direction: direction)
        
        if direction == .right {
            
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
            
//        } else {
//            // <--- PREVIOUS CARD <---
//            
//            guard let incomingCard = tempPreviousWrapper else { return }
//            
//            // 1. Доводимо анімацію попередньої картки до центру
//            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut) {
//                incomingCard.center = self.center
//                incomingCard.transform = .identity
//            } completion: { _ in
//                // 2. Коли анімація завершилась, оновлюємо структуру
//                
//                // Стара верхня стає задньою
//                self.backCardWrapper?.removeFromSuperview() // Видаляємо стару задню (вона нам більше не треба)
//                
//                self.backCardWrapper = self.topCardWrapper
//                self.applyBackCardTransform(self.backCardWrapper!)
//                self.sendSubviewToBack(self.backCardWrapper!)
//                
//                // Та, що прилетіла, стає верхньою
//                self.topCardWrapper = incomingCard
//                self.tempPreviousWrapper = nil
//                
//                // Оновлюємо індекс
//                self.currentIndex = (self.currentIndex - 1 + total) % total
//            }
        }
    }
    
    private func applyNextCardTransform(_ card: UIView) {
        let scale = CGAffineTransform(scaleX: 0.9, y: 0.9)
        let translate = CGAffineTransform(translationX: 0, y: 15)
        card.transform = scale.concatenating(translate)
    }
}
