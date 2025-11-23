import UIKit

class UICardView: UIView {
    
    private var panGesture: UIPanGestureRecognizer!
    private var originalPoint: CGPoint = .zero
    
    // Налаштування фізики
    private let threshold: CGFloat = 100 // Скільки треба протягнути, щоб зарахувався свайп
    private let rotationAngle: CGFloat = CGFloat.pi / 10 // Максимальний кут нахилу
    
    // Callbacks для StackView
    internal var onSwipeCompletion: ((SwipeDirection) -> Void)?
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupGesture()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        setupGesture()
    }
    
    private func setupGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc private func handlePan(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: self)
        
        switch sender.state {
        case .began:
            originalPoint = self.center
            
        case .changed:
            // 1. Рухаємо картку за пальцем
            self.center = CGPoint(x: originalPoint.x + translation.x, y: originalPoint.y + translation.y)
            
            // 2. Додаємо обертання (чим далі від центру, тим сильніший нахил)
            // Використовуємо min/max, щоб обмежити обертання
            let rotationStrength = min(translation.x / UIScreen.main.bounds.width, 1)
            let rotationAngle = self.rotationAngle * rotationStrength
            
            // Застосовуємо трансформацію
            self.transform = CGAffineTransform(rotationAngle: rotationAngle)
            
        case .ended:
            // 3. Перевіряємо, чи достатньо далеко користувач протягнув картку
            if translation.x > threshold {
                finishSwipe(direction: .right)
            } else if translation.x < -threshold {
                finishSwipe(direction: .left)
            } else {
                // Повертаємо назад (Reset)
                UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut) {
                    self.center = self.originalPoint
                    self.transform = .identity
                }
            }
            
        default:
            break
        }
    }
    
    private func finishSwipe(direction: SwipeDirection) {
        // Анімація "вильоту" за екран
        let endX = direction == .right ? UIScreen.main.bounds.width * 2 : -UIScreen.main.bounds.width * 2
        
        UIView.animate(withDuration: 0.3) {
            self.center = CGPoint(x: endX, y: self.originalPoint.y)
        } completion: { _ in
            self.removeFromSuperview()
            self.onSwipeCompletion?(direction)
        }
    }
}
