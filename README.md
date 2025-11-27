# UICardStackView

A powerful and flexible iOS framework for creating interactive card stacks with swipe gestures, animations, and view reuse.

## Features

- **Swipe Gestures** — Cards can be swiped left or right with smooth animations
- **Endless Mode** — Cards can loop infinitely or be removed permanently
- **Double-Sided Cards** — Support for front/back views with flip animations
- **View Reuse** — Automatic card reuse pool for memory optimization
- **Flexible Configuration** — Customize spacing, scaling, swipe thresholds, and animations
- **Delegate & DataSource** — Familiar API pattern similar to UITableView/UICollectionView
- **Full Customization** — Complete control over card appearance and behavior

## Installation

### Swift Package Manager

Add MyFramework to your project via Xcode:

1. Go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/axterrr/MyFramework`
3. Select the version you want to use

Or add it to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/axterrr/MyFramework", from: "1.0.0")
]
```

### CocoaPods

Add this line to your `Podfile`:

```ruby
pod 'MyFrameworkHibskyi', '~> 1.0'
```

Then run:

```bash
pod install
```

## Quick Start

### Basic Setup

```swift
import MyFramework

class ViewController: UIViewController {
    
    private let cardStack = UICardStackView()
    private var items = ["Card 1", "Card 2", "Card 3", "Card 4", "Card 5"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add card stack to view
        view.addSubview(cardStack)
        cardStack.frame = CGRect(x: 20, y: 100, width: view.bounds.width - 40, height: 400)
        
        // Configure
        cardStack.config.maxVisibleCards = 3
        cardStack.config.yCardSpacing = 10
        cardStack.config.scaleFactor = 0.05
        cardStack.config.endless = true
        
        // Set data source and delegate
        cardStack.dataSource = self
        cardStack.delegate = self
        
        // Load data
        cardStack.reloadData()
    }
}

// MARK: - Data Source
extension ViewController: UICardStackViewDataSource {
    
    func cardStackView(in cardStack: UICardStackView) -> Int {
        return items.count
    }
    
    func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UICardView {
        let card = cardStack.dequeueReusableCard()
        
        // Create front view
        let frontLabel = UILabel()
        frontLabel.text = items[index]
        frontLabel.textAlignment = .center
        frontLabel.font = .systemFont(ofSize: 24, weight: .bold)
        
        card.frontView = frontLabel
        
        return card
    }
}

// MARK: - Delegate
extension ViewController: UICardStackViewDelegate {
    
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection) {
        print("Swiped card \(index) to \(direction)")
    }
    
    func cardStackView(_ cardStack: UICardStackView, didTapCardAt index: Int) {
        print("Tapped card \(index)")
    }
}
```

## Configuration

Customize the card stack behavior using `UICardStackViewConfig`:

```swift
var config = UICardStackViewConfig()

// Loop cards infinitely
config.endless = true

// Number of visible cards in the stack
config.maxVisibleCards = 3

// Horizontal spacing for each card
config.xCardSpacing = 0

// Vertical spacing for each card
config.yCardSpacing = 10

// Scale factor - each card behind is 5% smaller
config.scaleFactor = 0.05

// Minimum swipe distance to trigger swipe action
config.swipeThreshold = 100

// Maximum rotation angle during swipe (in radians)
config.rotationMax = .pi / 10

// Animation duration in seconds
config.animationDuration = 0.3

// Opacity reduction rate while dragging
config.opacityRate = 0.2

cardStack.config = config
```

### Configuration Properties

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `endless` | `Bool` | `true` | Cards loop infinitely when `true` |
| `maxVisibleCards` | `Int` | `1` | Maximum number of cards visible at once |
| `xCardSpacing` | `CGFloat` | `0` | Horizontal offset for stacked cards |
| `yCardSpacing` | `CGFloat` | `0` | Vertical offset for stacked cards |
| `scaleFactor` | `CGFloat` | `0` | Scale reduction for each card in background |
| `swipeThreshold` | `CGFloat` | `100` | Minimum drag distance to trigger swipe |
| `rotationMax` | `CGFloat` | `0` | Maximum rotation angle during drag |
| `animationDuration` | `TimeInterval` | `0.25` | Duration of animations |
| `opacityRate` | `CGFloat` | `0` | Opacity reduction while dragging |

## Double-Sided Cards

Create cards with front and back views that flip on tap:

```swift
func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UICardView {
    let card = cardStack.dequeueReusableCard()
    
    // Front view
    let frontView = UIImageView(image: UIImage(named: "photo_\(index)"))
    frontView.contentMode = .scaleAspectFill
    card.frontView = frontView
    
    // Back view (optional)
    let backLabel = UILabel()
    backLabel.text = "Card Details"
    backLabel.textAlignment = .center
    backLabel.backgroundColor = .systemGray6
    card.backView = backLabel
    
    return card
}
```

When a card has both `frontView` and `backView` set, tapping the card will trigger a flip animation.

## Data Source

Implement `UICardStackViewDataSource` to provide content:

```swift
protocol UICardStackViewDataSource: AnyObject {
    
    // Return the total number of cards
    func cardStackView(in cardStack: UICardStackView) -> Int
    
    // Return a configured card for the given index
    func cardStackView(_ cardStack: UICardStackView, viewForCardAt index: Int) -> UICardView
}
```

## Delegate Methods

All delegate methods are optional and provide lifecycle events:

```swift
protocol UICardStackViewDelegate: AnyObject {
    
    // Called when user starts dragging the top card
    func cardStackView(_ cardStack: UICardStackView, didBeginDraggingCardAt index: Int)
    
    // Called continuously while dragging
    func cardStackView(_ cardStack: UICardStackView, didDragCardAt index: Int, translation: CGPoint)
    
    // Called when drag is cancelled (card snaps back)
    func cardStackView(_ cardStack: UICardStackView, didCancelSwipeCardAt index: Int)
    
    // Called when swipe threshold is reached (before animation)
    func cardStackView(_ cardStack: UICardStackView, willSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    
    // Called after swipe animation completes
    func cardStackView(_ cardStack: UICardStackView, didSwipeCardAt index: Int, direction: UICardViewSwipeDirection)
    
    // Called when user taps a card
    func cardStackView(_ cardStack: UICardStackView, didTapCardAt index: Int)
    
    // Called when all cards are swiped (only if endless = false)
    func cardStackViewDidRunOutOfCards(_ cardStack: UICardStackView)
    
    // Called after reloadData() completes
    func cardStackViewDidReloadData(_ cardStack: UICardStackView)
}
```

## Use Cases

- **Dating Apps** — Tinder-style profile browsing
- **Flashcards** — Educational apps with flip cards
- **Product Browsing** — E-commerce product discovery
- **Recipe Apps** — Swipeable recipe cards
- **News Readers** — Article browsing interfaces
- **Image Galleries** — Interactive photo viewers

## Public Methods

### UICardStackView

```swift
// Reload all cards from data source
func reloadData()

// Get a reusable card from the pool
func dequeueReusableCard() -> UICardView
```

### UICardView

```swift
// Reset card state for reuse
func prepareForReuse()

// Properties
var frontView: UIView?  // Front side content
var backView: UIView?   // Back side content (optional)
```

## Requirements

- iOS 13.0+
- Swift 5.0+
- Xcode 13.0+

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Author

**Hibskyi Vladyslav**  
[GitHub](https://github.com/axterrr)

## Contributing

Contributions, issues, and feature requests are welcome!  
Feel free to check [issues page](https://github.com/axterrr/MyFramework/issues).
