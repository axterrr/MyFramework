import UIKit

public class UICardStackView: UIView {
    
    public weak var dataSource: UICardStackDataSource?
    public weak var delegate: UICardStackDelegate?
    
    private var currentIndex = 0
    
    public func reloadData() {
        subviews.forEach { $0.removeFromSuperview() }
        currentIndex = 0
        loadNextCards()
    }
    
    private func loadNextCards() {
        guard let dataSource = dataSource else { return }
        let cardsNumber = dataSource.numberOfCards(in: self)
    }
}
