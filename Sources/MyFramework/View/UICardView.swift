import UIKit

open class UICardView: UIView {
    
    public var frontView: UIView? {
        didSet { setupView(frontView, inside: frontContainer) }
    }
    
    public var backView: UIView? {
        didSet { setupView(backView, inside: backContainer) }
    }
    
    private let frontContainer = UIView()
    private let backContainer = UIView()
    
    var onDidTap: (() -> Void)?
    var onDrag: ((CGFloat) -> Void)?
    var onWillSwipe: ((UICardViewSwipeDirection) -> Void)?
    var onDidSwipe: ((UICardViewSwipeDirection) -> Void)?
    
    private var isShowingBack = false
    private var originalCenter: CGPoint = .zero
    
    var swipeThreshold: CGFloat = 100
    var rotationMax: CGFloat = .pi / 10
    var animationDuration: TimeInterval = 0.25
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
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
        self.layer.masksToBounds = false
        
        [frontContainer, backContainer].forEach({ contentainer in
            contentainer.frame = self.bounds
            contentainer.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            contentainer.backgroundColor = .white
            contentainer.layer.cornerRadius = 20
            contentainer.layer.masksToBounds = true
            contentainer.layer.borderWidth = 1
            contentainer.layer.borderColor = UIColor.systemGray5.cgColor
            addSubview(contentainer)
        })
        
        backContainer.isHidden = true
    }
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        guard let superview = self.superview else { return }
        let translation = sender.translation(in: superview)
        let xOffset = translation.x
        
        switch sender.state {
        case .began:
            originalCenter = self.center
            
        case .changed:
            self.center = CGPoint(x: originalCenter.x + xOffset, y: originalCenter.y + (translation.y * 0.5))
            let strength = xOffset / (swipeThreshold * 2)
            let cappedStrength = min(max(strength, -1.0), 1.0)
            let rotationAngle = cappedStrength * rotationMax
            self.transform = CGAffineTransform(rotationAngle: rotationAngle)
            onDrag?(xOffset)
            
        case .ended:
            if xOffset > swipeThreshold {
                animateSwipe(direction: .right)
            } else if xOffset < -swipeThreshold {
                animateSwipe(direction: .left)
            } else {
                resetPosition()
            }
            
        default:
            resetPosition()
        }
    }
    
    private func resetPosition() {
        UIView.animate(
            withDuration: animationDuration,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 1,
            options: .curveEaseOut
        ) {
            self.center = self.originalCenter
            self.transform = .identity
            self.alpha = 1
        }
    }
    
    func prepareForReuse() {
        frontView = nil
        backView = nil
        onDidTap = nil
        onDrag = nil
        onDidSwipe = nil
        onWillSwipe = nil
        transform = .identity
        alpha = 1.0
        originalCenter = .zero
        center = originalCenter
        isShowingBack = false
        frontContainer.isHidden = false
        backContainer.isHidden = true
        swipeThreshold = 100
        rotationMax = .pi / 10
        animationDuration = 0.25
    }
    
    private func animateSwipe(direction: UICardViewSwipeDirection) {
        let screenWidth = UIScreen.main.bounds.width
        let targetX = direction == .right ? screenWidth * 1.5 : -screenWidth * 1.5
        let flyAwayPoint = CGPoint(x: targetX, y: originalCenter.y + 50)
        
        onWillSwipe?(direction)
        
        UIView.animate(withDuration: animationDuration) {
            self.center = flyAwayPoint
            let angle = direction == .right ? self.rotationMax : -self.rotationMax
            self.transform = CGAffineTransform(rotationAngle: angle)
        } completion: { _ in
            self.onDidSwipe?(direction)
        }
    }
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        onDidTap?()
        if let backView {
            flip()
        }
    }
    
    private func flip() {
        let transitionOptions: AnimationOptions = isShowingBack ? .transitionFlipFromLeft : .transitionFlipFromRight
        
        let viewToShow = isShowingBack ? frontContainer : backContainer
        let viewToHide = isShowingBack ? backContainer : frontContainer
        
        UIView.transition(
            with: self,
            duration: animationDuration,
            options: transitionOptions,
            animations: {
                viewToHide.isHidden = true
                viewToShow.isHidden = false
            }
        ) { _ in
            self.isShowingBack.toggle()
        }
    }
    
    private func setupView(_ view: UIView?, inside container: UIView) {
        container.subviews.forEach { $0.removeFromSuperview() }
        guard let view = view else { return }
        container.addSubview(view)
        view.frame = container.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}
