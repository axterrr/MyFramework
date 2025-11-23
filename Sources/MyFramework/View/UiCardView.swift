import UIKit

public class UICardView: UIView {
    
    let frontContainer = UIView()
    
    var onDrag: ((CGFloat) -> Void)?
    var onSwipeEnd: ((SwipeDirection) -> Void)?
    
    private var originalCenter: CGPoint = .zero
    private let threshold: CGFloat = 100
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        setupStyle()
        setupGestures()
    }
    
    private func setupStyle() {
        self.backgroundColor = .clear
        self.layer.cornerRadius = 20
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowRadius = 6
        
        frontContainer.frame = self.bounds
        frontContainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        frontContainer.backgroundColor = .white
        frontContainer.layer.cornerRadius = 20
        frontContainer.layer.masksToBounds = true
        frontContainer.layer.borderWidth = 1
        frontContainer.layer.borderColor = UIColor.systemGray5.cgColor
        addSubview(frontContainer)
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        let xOffset = translation.x
        
        switch sender.state {
        case .began:
            originalCenter = self.center
            
        case .changed:
            self.center = CGPoint(x: originalCenter.x + xOffset, y: originalCenter.y + (translation.y * 0.5))
            let rotationAngle = (xOffset / 300) * (CGFloat.pi / 12)
            self.transform = CGAffineTransform(rotationAngle: rotationAngle)
            onDrag?(xOffset)
            
        case .ended:
            if xOffset > threshold {
                animateFlyAway(direction: .right)
            } else if xOffset < -threshold {
                animateFlyAway(direction: .left)
            } else {
                resetPosition()
            }
            
        default:
            resetPosition()
        }
    }
    
    public func resetPosition() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.center = self.originalCenter
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    private func animateFlyAway(direction: SwipeDirection) {
        let screenWidth = UIScreen.main.bounds.width
        let targetX = direction == .right ? screenWidth * 1.5 : -screenWidth * 1.5
        let flyAwayPoint = CGPoint(x: targetX, y: originalCenter.y + 50)
        
        UIView.animate(withDuration: 0.3) {
            self.center = flyAwayPoint
            let angle = direction == .right ? CGFloat.pi / 4 : -CGFloat.pi / 4
            self.transform = CGAffineTransform(rotationAngle: angle)
        } completion: { _ in
            self.onSwipeEnd?(direction)
        }
    }
}
