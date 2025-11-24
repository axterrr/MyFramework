import Foundation

public struct UICardStackViewConfig {
    public var scaleFactor: CGFloat = 0.04
    public var swipeThreshold: CGFloat = 100
    public var rotationMax: CGFloat = .pi / 10
    public var animationDuration: TimeInterval = 0.25
    public var oparcityRate: CGFloat = 0.3
    public init() {}
}
