import UIKit

/// A protocol that handles user interactions and lifecycle events of the `UICardStackView`.
public protocol UICardStackViewDelegate: AnyObject {
    
    /// Called when the user starts dragging the top card.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the card being dragged.
    func cardStackView(_ cardStack: UICardStackView, didBeginDraggingCardAt index: Int)
    
    /// Called repeatedly as the user moves the card.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the card.
    ///   - translation: The current translation (offset) of the card from its center.
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGPoint)
    
    /// Called when the user releases the card without reaching the swipe threshold.
    /// The card will animate back to its original position.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the card.
    func cardStackView(_ cardStack: UICardStackView, didCancelSwipeCardAt index: Int)
    
    /// Called when a swipe gesture is confirmed (threshold reached) but before the animation completes.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the card being swiped.
    ///   - direction: The direction of the swipe (left or right).
    func cardStackView(_ cardStack: UICardStackView, willSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    
    /// Called after the swipe animation has fully completed and the card is removed from the view.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the swiped card.
    ///   - direction: The direction of the swipe.
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    
    /// Called when the user taps on the top card.
    /// - Parameters:
    ///   - cardStack: The stack view instance.
    ///   - index: The index of the tapped card.
    func cardStackView(_ cardStack: UICardStackView, didTapCardAt index: Int)
    
    /// Called when there are no more cards to display.
    /// This is only called if `endless` is set to `false` in the configuration.
    /// - Parameter cardStack: The stack view instance.
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView)
    
    /// Called after `reloadData()` has finished reloading the stack.
    /// - Parameter cardStack: The stack view instance.
    func cardStackViewDidReloadData(_ cardStack: UICardStackView)
}

// MARK: - Default Implementation (Optional Methods)
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
