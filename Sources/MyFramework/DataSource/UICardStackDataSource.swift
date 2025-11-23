import UIKit

public protocol UICardStackDataSource: AnyObject {
    func numberOfCards(in cardStack: UICardStackView) -> Int
    func cardStack(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UIView
    func cardStack(_ cardStack: UICardStackView, backViewForCardAt index: Int) -> UIView?
}

public extension UICardStackDataSource {
    func cardStack(_ cardStack: UICardStackView, backViewForCardAt index: Int) -> UIView? {
        return nil
    }
}
