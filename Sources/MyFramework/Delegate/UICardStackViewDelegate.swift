import UIKit

public protocol UICardStackViewDelegate: AnyObject {
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    func cardStackView(_ stack: UICardStackView, didTapCardAt index: Int)
}

public extension UICardStackViewDelegate {
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection) {}
    func cardStackView(_ stack: UICardStackView, didTapCardAt index: Int) {}
}
