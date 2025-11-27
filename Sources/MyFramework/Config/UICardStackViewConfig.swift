import Foundation

public struct UICardStackViewConfig {
    public var endless: Bool = true
    public var maxVisibleCards: Int = 1
    public var xCardSpacing: CGFloat = 0
    public var yCardSpacing: CGFloat = 0
    public var scaleFactor: CGFloat = 0
    public var swipeThreshold: CGFloat = 100
    public var rotationMax: CGFloat = 0
    public var animationDuration: TimeInterval = 0.25
    public var opacityRate: CGFloat = 0
    public init() {}
}
