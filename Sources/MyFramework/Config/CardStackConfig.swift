import Foundation

public struct CardStackConfig {
    public var maxVisibleCards: Int = 3
    public var cardSpacing: CGFloat = 12
    public var scaleFactor: CGFloat = 0.04
    public var swipeThreshold: CGFloat = 100
    public var rotationMax: CGFloat = .pi / 10
    public var animationDuration: TimeInterval = 0.25

    public init() {}
}
