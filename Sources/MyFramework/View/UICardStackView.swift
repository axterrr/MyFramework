import UIKit

public class UICardStackView: UIView {
    
    public weak var dataSource: UICardStackDataSource?
    public weak var delegate: UICardStackDelegate?
    
    private var currentIndex = 0
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        currentIndex = 0
        loadTopCards()
    }
    
    private func loadTopCards() {
        guard let dataSource = dataSource else { return }
        let cardsNumber = dataSource.numberOfCards(in: self)
        
        if currentIndex >= cardsNumber {
            currentIndex = 0
            return
        }
        
        let nextIndex = currentIndex + 1
        if nextIndex < cardsNumber {
            addCard(at: nextIndex, isTop: false)
        } else {
            if currentIndex > 0 {
                addCard(at: 0, isTop: false)
            }
        }
        addCard(at: currentIndex, isTop: true)
    }
    
    private func addCard(at index: Int, isTop: Bool) {
        guard let cardView = dataSource?.cardStack(self, viewForCardAt: index) else { return }
        
        let container = UICardView(frame: self.bounds)
        container.addSubview(cardView)
        cardView.frame = container.bounds
        
        if isTop {
            container.isUserInteractionEnabled = true
            container.onSwipeCompletion = { [weak self] direction in
                guard let self = self else { return }
                self.currentIndex += 1
                self.loadTopCards()
            }
        } else {
            container.isUserInteractionEnabled = false
        }
        
        self.addSubview(container)
    }
}
