//
//  XLabelsLayer.swift
//  iCharts
//
//  Created by Volodymyr Hryhoriev on 3/19/19.
//  Copyright © 2019 Volodymyr Hryhoriev. All rights reserved.
//

final class XLabelsLayer: CALayer {
    
    func render(props: Props) {
        backgroundColor = UIColor.clear.cgColor
        frame = props.rect
        
        renderLabels(props: props)
    }
    
    private func renderLabels(props: Props) {
        sublayers = props.labels.map {
            makeTextLayer(
                label: $0,
                labelWidth: props.labelWidth,
                textColor: props.textColor)
        }
    }
    
    private func makeTextLayer(label: Props.Label, labelWidth: CGFloat, textColor: CGColor) -> CATextLayer {
        let fontSize: CGFloat = 12.0
        
        let layer = CATextLayer(string: label.value, textColor: textColor, fontSize: fontSize)
        
        layer.frame.size.width = labelWidth
        
        layer.frame.origin.x += label.point.x
        layer.frame.origin.y += frame.size.height / 2 - fontSize / 2
        
        return layer
    }
}

extension XLabelsLayer {
    
    struct Props {
        let labels: [Label]
        let labelWidth: CGFloat
        let textColor: CGColor
        let rect: CGRect
        
        struct Label {
            let point: CGPoint
            let value: String
        }
    }
}