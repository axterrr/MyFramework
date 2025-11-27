import UIKit

public protocol UICardStackViewDelegate: AnyObject {
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGFloat)
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    func cardStackView(_ stack: UICardStackView, didTapCardAt index: Int)
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView)
}

public extension UICardStackViewDelegate {
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGFloat) {}
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection) {}
    func cardStackView(_ stack: UICardStackView, didTapCardAt index: Int) {}
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView) {}
}
