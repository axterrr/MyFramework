import Foundation

/// Configuration struct for customizing the appearance and behavior of `UICardStackView`.
/// 
/// Use this struct to define properties like card spacing, visible count, swipe thresholds, and animation durations.
public struct UICardStackViewConfig {
    
    /// Determines if the card stack should loop infinitely.
    /// - `true`: Cards will reappear at the bottom of the stack after being swiped.
    /// - `false`: Cards will be removed permanently. When the last card is swiped, the stack becomes empty.
    public var endless: Bool = true
    
    /// The maximum number of cards visible on the screen at the same time.
    /// This creates the "stack" depth effect.
    public var maxVisibleCards: Int = 1
    
    /// The horizontal offset (in points) for each subsequent card in the stack.
    /// Use this to create a "fanned out" look.
    public var xCardSpacing: CGFloat = 0
    
    /// The vertical offset (in points) for each subsequent card in the stack.
    public var yCardSpacing: CGFloat = 0
    
    /// The scaling factor for cards in the background.
    /// A value of `0.05` means each card behind the top one will be 5% smaller.
    public var scaleFactor: CGFloat = 0
    
    /// The minimum distance (in points) a user must drag a card for it to be considered a "swipe".
    /// If the drag is less than this value, the card snaps back to the center.
    public var swipeThreshold: CGFloat = 100
    
    /// The maximum rotation angle (in radians) applied to the card as it is dragged horizontally.
    public var rotationMax: CGFloat = 0
    
    /// The duration (in seconds) for card animations (swiping away, snapping back, resetting).
    public var animationDuration: TimeInterval = 0.25
    
    /// The opacity reduction rate for background cards or while dragging.
    /// A value of `0` means no opacity change.
    public var opacityRate: CGFloat = 0
    
    /// Initializes a default configuration.
    public init() {}
}
