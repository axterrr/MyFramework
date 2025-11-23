import UIKit

public protocol UICardStackViewDataSource: AnyObject {
    func cardStackView(in cardStack: UICardStackView) -> Int
    func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UIView
    func cardStackView(_ cardStack: UICardStackView, backViewForCardAt index: Int) -> UIView?
}

public extension UICardStackViewDataSource {
    func cardStackView(_ cardStack: UICardStackView, backViewForCardAt index: Int) -> UIView? {
        return nil
    }
}
