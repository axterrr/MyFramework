import UIKit

public protocol UICardStackViewDataSource: AnyObject {
    func cardStackView(in cardStack: UICardStackView) -> Int
    func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UICardView
}
