import UIKit

public protocol UICardStackViewDelegate: AnyObject {
    func cardStackView(_ cardStack: UICardStackView, didBeginDraggingCardAt index: Int)
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGPoint)
    func cardStackView(_ cardStack: UICardStackView, didCancelSwipeCardAt index: Int)
    func cardStackView(_ cardStack: UICardStackView, willSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    func cardStackView(_ cardStack: UICardStackView, didTapCardAt index: Int)
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView)
    func cardStackViewDidReloadData(_ cardStack: UICardStackView)
}

public extension UICardStackViewDelegate {
    func cardStackView(_ cardStack: UICardStackView, didBeginDraggingCardAt index: Int) {}
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGPoint) {}
    func cardStackView(_ cardStack: UICardStackView, didCancelSwipeCardAt index: Int) {}
    func cardStackView(_ cardStack: UICardStackView, willSwipeCardAt index: Int, direction: UICardViewSwipeDirection) {}
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection) {}
    func cardStackView(_ cardStack: UICardStackView, didTapCardAt index: Int) {}
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView) {}
    func cardStackViewDidReloadData(_ cardStack: UICardStackView) {}
}
