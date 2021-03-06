//
//  LineLayer.swift
//  iCharts
//
//  Created by Volodymyr Hryhoriev on 3/13/19.
//  Copyright © 2019 Volodymyr Hryhoriev. All rights reserved.
//


final class LineLayer: CAShapeLayer {
    
    var circleColor: UIColor = .white {
        didSet {
            if circleLayer.fillColor != UIColor.clear.cgColor {
                circleLayer.fillColor = circleColor.cgColor
            }
        }
    }
    
    private let circleLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.backgroundColor = UIColor.clear.cgColor
        return layer
    }()
    
    override init() {
        super.init()
        addSublayer(circleLayer)
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // MARK: - Render
    
    func render(props: Props) {
        renderLinePath(props: props)
        renderCircleLayer(props: props)
    }
    
    private func renderLinePath(props: Props) {
        let path = makePath(using: props).cgPath
        renderPath(
            layer: self,
            path: path,
            lineWidth: props.lineWidth,
            strokeColor: props.line.color.cgColor,
            fillColor: UIColor.clear.cgColor,
            animated: props.isAnimated)
    }
    
    private func renderPath(layer: CAShapeLayer,
                         path: CGPath?,
                         lineWidth: CGFloat,
                         strokeColor: CGColor,
                         fillColor: CGColor,
                         animated isAnimated: Bool) {
        
        let strokeColor = strokeColor
        let lineWidth = lineWidth
        
        var duration: CFTimeInterval?
        if !isAnimated {
            duration = 0
        }
        
        layer.animate(
            duration: duration,
            group: [
                .path(path),
                .fillColor(fillColor),
                .strokeColor(strokeColor),
                .lineWidth(lineWidth)
            ])
    }
    
    private func makePath(using props: Props) -> UIBezierPath {
        let path = UIBezierPath()
        
        let linePath = makePath(using: props.line)
        path.append(linePath)
        
        return path
    }
    
    private func makePath(using line: Line) -> UIBezierPath {
        let path = UIBezierPath()
        
        var points = line.points
        let first = points.removeFirst()
        
        path.move(to: first)
        points.forEach { path.addLine(to: $0) }
        
        return path
    }
    
    private func renderCircleLayer(props: Props) {
        let path: UIBezierPath?
        let strokeColor: CGColor
        let fillColor: CGColor
        
        if let point = props.line.highlightedPoint {
            path = makeCircle(at: point, lineWidth: props.lineWidth)
            strokeColor = props.line.color.cgColor
            fillColor = circleColor.cgColor
        } else {
            path = nil
            strokeColor = UIColor.clear.cgColor
            fillColor = UIColor.clear.cgColor
        }
        
        renderPath(
            layer: circleLayer,
            path: path?.cgPath,
            lineWidth: props.lineWidth,
            strokeColor: strokeColor,
            fillColor: fillColor,
            animated: props.isAnimated)
    }
    
    private func makeCircle(at point: CGPoint, lineWidth: CGFloat) -> UIBezierPath {
        let diametr = 3 * lineWidth
        let radius = 0.5 * diametr
        let rect = CGRect(
            x: point.x - radius,
            y: point.y - radius,
            width: diametr,
            height: diametr)
        return UIBezierPath(ovalIn: rect)
    }
}

extension LineLayer {
    
    struct Props {
        let line: Line
        let lineWidth: CGFloat
        var isAnimated: Bool
        
        init(line: Line, lineWidth: CGFloat, isAnimated: Bool = true) {
            self.line = line
            self.lineWidth = lineWidth
            self.isAnimated = isAnimated
        }
    }
}
