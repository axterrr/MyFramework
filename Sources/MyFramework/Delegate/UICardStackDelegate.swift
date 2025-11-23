import UIKit

public protocol UICardStackDelegate: AnyObject {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: SwipeDirection)
}

public extension UICardStackDelegate {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: SwipeDirection) {}
}
