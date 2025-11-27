import UIKit

/// A protocol that provides the content for the `UICardStackView`.
public protocol UICardStackViewDataSource: AnyObject {
    
    /// Asks the data source for the total number of cards to display.
    /// - Parameter cardStack: The stack view requesting this information.
    /// - Returns: The total number of items.
    func cardStackView(in cardStack: UICardStackView) -> Int
    
    /// Asks the data source for a card view to display at a specific index.
    ///
    /// It is recommended to use `dequeueReusableCard()` within this method to reuse card instances.
    ///
    /// - Parameters:
    ///   - cardStack: The stack view requesting the card.
    ///   - index: The index of the item.
    /// - Returns: A configured `UICardView` instance.
    func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UICardView
}
