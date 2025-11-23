import UIKit

public class UICardView: UIView {
    
    let frontContainer = UIView()
    
    var onDragRight: ((CGFloat) -> Void)?
    var onDragLeft: ((CGFloat) -> Void)?
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
            if xOffset > 0 {
                self.center = CGPoint(x: originalCenter.x + xOffset, y: originalCenter.y + (translation.y * 0.5))
                let rotationAngle = (xOffset / 300) * (CGFloat.pi / 12)
                self.transform = CGAffineTransform(rotationAngle: rotationAngle)
                onDragRight?(xOffset)
            } else {
                resetPosition()
                onDragLeft?(xOffset)
            }
            
        case .ended:
            if xOffset > threshold {
                animateFlyAway()
            } else if xOffset < -threshold {
                onSwipeEnd?(.left)
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
    
    private func animateFlyAway() {
        let flyAwayPoint = CGPoint(x: UIScreen.main.bounds.width * 1.5, y: originalCenter.y + 50)
        
        UIView.animate(withDuration: 0.3) {
            self.center = flyAwayPoint
            self.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 4)
        } completion: { _ in
            self.onSwipeEnd?(.right)
        }
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
//    }
//    
//    
//    var frontView: UIView?
//    var backView: UIView?
//    
//    private(set) var isShowingBack = false
//    
//    var onDidTap: (() -> Void)?
//    var onPanUpdate: ((CGFloat) -> Void)?
//    var onSwipeAction: ((SwipeDirection) -> Void)?
//    
//    private let frontContainer = UIView()
//    private let backContainer = UIView()
//    
//    private func setupContainers() {
//        [frontContainer, backContainer].forEach {
//            addSubview($0)
//            $0.frame = bounds
//            $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//            $0.layer.cornerRadius = 16
//            $0.clipsToBounds = true
//            $0.backgroundColor = .white
//        }
//        
//        backContainer.isHidden = true
//        // backContainer.transform = CGAffineTransform(scaleX: -1, y: 1)
//    }
//    
//    private func setupView(_ view: UIView?, inside container: UIView) {
//        container.subviews.forEach { $0.removeFromSuperview() }
//        guard let view = view else { return }
//        container.addSubview(view)
//        view.frame = container.bounds
//        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//    }
//    
//    @objc private func handleTap(_ sender: UITapGestureRecognizer) {
//        guard backView != nil else {
//            onDidTap?()
//            return
//        }
//        flip()
//    }
//    
//    public func flip() {
//        let transitionOptions: UIView.AnimationOptions = isShowingBack ? .transitionFlipFromLeft : .transitionFlipFromRight
//        
//        let viewToShow = isShowingBack ? frontContainer : backContainer
//        let viewToHide = isShowingBack ? backContainer : frontContainer
//        
//        UIView.transition(with: self, duration: 0.4, options: transitionOptions, animations: {
//            viewToHide.isHidden = true
//            viewToShow.isHidden = false
//        }) { _ in
//            self.isShowingBack.toggle()
//        }
//    }
}
