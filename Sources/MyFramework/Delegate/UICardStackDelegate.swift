import UIKit

public protocol UICardStackDelegate: AnyObject {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection)
    func cardStackDidRunOutOfCards(_ cardStack: UICardStackView)
}

public extension UICardStackDelegate {
    func cardStack(_ cardStack: UICardStackView, didSwipeCardAt index: Int, with direction: SwipeDirection) {}
    func cardStackDidRunOutOfCards(_ cardStack: UICardStackView) {}
}
