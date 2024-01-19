import UIKit

final class TabBarView: UITabBar {
    
    private var shapeLayer: CAShapeLayer?
    var centeredWidth: CGFloat = 0
    
    override func draw(_ rect: CGRect) {
        centeredWidth = self.bounds.width / 6
        //centeredWidth = self.bounds.origin.x
        self.unselectedItemTintColor = .white
        self.tintColor = .white
        self.addShape()
    }
    
    func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = getPath()
        shapeLayer.strokeColor = UIColor.clear.cgColor
        shapeLayer.fillColor = UIColor.backgroundColorTabBar.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.shadowOffset = CGSize(width: 0, height: 0)
        shapeLayer.shadowColor = UIColor.black.cgColor
        shapeLayer.shadowOpacity = 1
        
        if let oldShape = self.shapeLayer {
            self.layer.replaceSublayer(oldShape, with: shapeLayer)
        } else {
            layer.insertSublayer(shapeLayer, at: 0)
        }
        self.shapeLayer = shapeLayer
    }
    
    //кастомный метод для определения пути
    private func getPath() -> CGPath {
        let height: CGFloat = 45
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        
        path.addLine(to: CGPoint(x: centeredWidth - height * 2, y: 0))
        
        //первое закругление (слева вниз)
        path.addCurve(to: CGPoint(x: centeredWidth, y: height),
                      controlPoint1: CGPoint(x: centeredWidth - 30, y: 0),
                      controlPoint2: CGPoint(x: centeredWidth - 35, y: height))
        
        //второе закругление напротив первого
        path.addCurve(to: CGPoint(x: centeredWidth + height * 2, y: 0),
                      controlPoint1: CGPoint(x: centeredWidth + 35, y: height),
                      controlPoint2: CGPoint(x: centeredWidth + 30, y: 0))
        
        //линии, по которым будет идти закругление
        path.addLine(to: CGPoint(x: self.bounds.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        path.close()
        return path.cgPath
    }
    
    func updateCurveForTappedIndex() {
        //получаем выбранное вью
        guard let selectedTab = self.selectedItem?.value(forKey: "view") as? UIView else { return }
        
        //получаем центр выбранного вью
        self.centeredWidth = selectedTab.frame.origin.x + (selectedTab.frame.width / 2)
        
        //вызываем метод, чтобы перерисовать слой
        addShape()
    }
    
}

