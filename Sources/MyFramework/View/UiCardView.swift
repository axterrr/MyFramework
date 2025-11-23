import UIKit

class UICardView: UIView {
    
    var frontView: UIView? {
        didSet { setupView(frontView, inside: frontContainer) }
    }
    
    var backView: UIView? {
        didSet { setupView(backView, inside: backContainer) }
    }
    
    private let frontContainer = UIView()
    private let backContainer = UIView()
    
    var onDidTap: (() -> Void)?
    var onDrag: ((CGFloat) -> Void)?
    var onSwipeEnd: ((UICardViewSwipeDirection) -> Void)?
    
    private var isShowingBack = false
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
                animateSwipe(direction: .right)
            } else if xOffset < -threshold {
                animateSwipe(direction: .left)
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
    
    private func animateSwipe(direction: UICardViewSwipeDirection) {
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
    
    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
        onDidTap?()
        guard backView != nil else { return }
        flip()
    }
    
    private func flip() {
        let transitionOptions: AnimationOptions = isShowingBack ? .transitionFlipFromLeft : .transitionFlipFromRight
        
        let viewToShow = isShowingBack ? frontContainer : backContainer
        let viewToHide = isShowingBack ? backContainer : frontContainer
        
        UIView.transition(with: self, duration: 0.4, options: transitionOptions, animations: {
            viewToHide.isHidden = true
            viewToShow.isHidden = false
        }) { _ in
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
