import UIKit

public protocol UICardStackDelegate: AnyObject {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: SwipeDirection)
    func cardStack(_ stack: UICardStackView, didTapCardAt index: Int)
}

public extension UICardStackDelegate {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: SwipeDirection) {}
    func cardStack(_ stack: UICardStackView, didTapCardAt index: Int) {}
}
