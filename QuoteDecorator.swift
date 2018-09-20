//
//  QuoteDecorator.swift
//  RxPractice2
//
//  Created by Mobexs on 9/20/18.
//  Copyright © 2018 SergeRylko. All rights reserved.
//

import UIKit

protocol QuoteDecorated {

}

extension QuoteDecorated where Self: UIView {

    @discardableResult
    func addQuoteDecoration(tongueOffsetX: CGFloat, tongueSide: CGFloat, cornerRadius: CGFloat, borderWidth: CGFloat, borderColor: UIColor, fillColor: UIColor) -> (borderLayer: CALayer, innerLayer: CALayer){

        let doubleBorder: CGFloat = borderWidth * 2.0
        let semiBorder: CGFloat = borderWidth / 2
        let angle: CGFloat = .pi / 4 // 45'
        let angleCos : CGFloat = cos(angle)
        let marginToContentRect = tongueSide/2 * angleCos + semiBorder
        let tongueOrigin = CGPoint(x: tongueOffsetX, y: marginToContentRect)
        let aPath = CGMutablePath.init()

        //setup Content rect
        let contentRect = CGRect(x: bounds.origin.x + semiBorder,
                                 y: bounds.origin.y + tongueSide / 2 + borderWidth,
                                 width: bounds.width - borderWidth,
                                 height: bounds.height - doubleBorder - marginToContentRect)

        aPath.addRoundedRect(in: contentRect, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

        //setup Tongue rect
        let tongueRect = CGRect(origin: tongueOrigin,
                                size: CGSize(width: tongueSide, height: tongueSide))

        //rotate tongue
        let centerRotatePoint = CGPoint(x: tongueRect.midX, y: tongueRect.midY)
        var tra = CGAffineTransform.init(translationX: centerRotatePoint.x, y: centerRotatePoint.y)

        tra = tra.rotated(by: angle)
        tra = tra.translatedBy(x: -centerRotatePoint.x, y: -centerRotatePoint.y)

        aPath.addRect(tongueRect, transform: tra)

        //merge paths
        let other = aPath.copy(strokingWithWidth: borderWidth, lineCap: .round, lineJoin: .round, miterLimit: 1.0)

        //add layers
        let borderShapeLayer = CAShapeLayer()
        borderShapeLayer.fillColor = borderColor.cgColor
        borderShapeLayer.path = other
        layer.addSublayer(borderShapeLayer)


        let innerShapeLayer = CAShapeLayer()
        innerShapeLayer.fillColor = fillColor.cgColor
        innerShapeLayer.path = aPath

        layer.addSublayer(innerShapeLayer)

        return (borderShapeLayer, innerShapeLayer)
    }
}
