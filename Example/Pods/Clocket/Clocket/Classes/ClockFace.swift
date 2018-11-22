//
//  ClockFace.swift
//  Clocket
//
//  Created by Andrey Filonov on 08/11/2018.
//  Copyright © 2018 Andrey Filonov. All rights reserved.
//

import UIKit


class ClockFace: UIImageView {
    
    private var staticClockFaceImage: UIImage?
    private var diameter: CGFloat { return min(frame.width, frame.height) }
    
    var lineWidthCoefficient = CGFloat(100.0)
    
    lazy var lineWidth = {
        return diameter / lineWidthCoefficient
    }()
    
    var lineColor = UIColor.black.cgColor
    var clockFaceSolidColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0).cgColor
    
    var markOffset = CGFloat(2.0)
    var minuteMarkLength = CGFloat(3.0)
    var minuteMarkWidth = CGFloat(1.0)
    var fiveMinuteMarkLength = CGFloat(4.0)
    var fiveMinuteMarkWidth = CGFloat(2.0)
    var quarterMarkLength = CGFloat(5.0)
    var quarterMarkWidth = CGFloat(3.0)
    
    var enableDigits = true
    var digitFontName = "HelveticaNeue"
    var digitFontCoefficient = CGFloat(10.0)
    var digitFont: UIFont { return UIFont(name: digitFontName, size: diameter/digitFontCoefficient)! }
    var digitOffset: CGFloat { return (quarterMarkLength * lineWidth)/2 + 1.0 }
    var digitColor = UIColor(red: 50/255, green: 50/255, blue: 50/255, alpha: 1.0) /* #7c7c7c */
    
    var enableLogo = true
    var logoText = "Clocket"
    var logoColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0) /* #7c7c7c */
    var logoFontName = "HelveticaNeue-bold"
    var logoFontCoefficient = CGFloat(20.0)
    var logoFont: UIFont { return UIFont(name: logoFontName, size: diameter/logoFontCoefficient)! }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    
    convenience init(frame: CGRect, staticClockFaceImage: UIImage?) {
        self.init(frame: frame)
        self.staticClockFaceImage = staticClockFaceImage
        setup()
    }
    
    
    func setup() {
        image = staticClockFaceImage ?? drawClockFace()
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func drawClockFace() -> UIImage {
        let perimeter = drawPerimeter()
        let marks = drawMarks()
        let digits = drawDigits()
        let logo = drawLogo()
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        return renderer.image { (ctx) in
            let origin = CGPoint(x: 0, y: 0)
            perimeter.draw(at: origin)
            marks.draw(at: origin)
            digits.draw(at: origin)
            logo.draw(at: origin)
        }
    }
    
    
    func drawPerimeter() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        return renderer.image { (ctx) in
            let rectangle = CGRect(x: lineWidth/2.0, y: lineWidth/2.0, width: diameter-lineWidth, height: diameter-lineWidth)
            ctx.cgContext.setFillColor(clockFaceSolidColor)
            ctx.cgContext.setStrokeColor(lineColor)
            ctx.cgContext.setLineWidth(lineWidth)
            ctx.cgContext.addEllipse(in: rectangle)
            ctx.cgContext.drawPath(using: .fillStroke)
        }
    }
    
    
    func drawMarks() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        return renderer.image { (ctx) in
            ctx.cgContext.translateBy(x: diameter/2, y: diameter/2)
            ctx.cgContext.setStrokeColor(lineColor)
            let startPoint = CGPoint(x: diameter/2 - lineWidth * markOffset, y: 0)
            for mark in 0..<60 {
                ctx.cgContext.move(to: startPoint)
                var endPoint = CGPoint(x: startPoint.x - minuteMarkLength * lineWidth, y: 0)
                ctx.cgContext.setLineWidth(minuteMarkWidth * lineWidth)
                
                if mark % 15 == 0 {
                    ctx.cgContext.setLineWidth(quarterMarkWidth * lineWidth)
                    endPoint = CGPoint(x: startPoint.x - quarterMarkLength * lineWidth, y: 0)
                } else if mark % 5 == 0 {
                    ctx.cgContext.setLineWidth(fiveMinuteMarkWidth * lineWidth)
                    endPoint = CGPoint(x: startPoint.x - fiveMinuteMarkLength * lineWidth, y: 0)
                }
                ctx.cgContext.addLine(to: endPoint)
                ctx.cgContext.drawPath(using: .fillStroke)
                ctx.cgContext.rotate(by: CGFloat(Double.pi/30))
            }
        }
    }
    
    
    func drawDigits() -> UIImage {
        if !enableDigits {return UIImage()}
        
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter,
                                                            height: diameter))
        let fontHeight = digitFont.lineHeight
        let halfFontHeight = fontHeight/2
        
        let center = CGPoint(x: diameter/2 - halfFontHeight/2,
                             y: diameter/2 - halfFontHeight)
        let digitDistanceFromCenter = (diameter-lineWidth)/2 - fontHeight/4 - digitOffset
        let attrs = [NSAttributedString.Key.font: digitFont, NSAttributedString.Key.foregroundColor: digitColor] as [NSAttributedString.Key : Any]
        
        return renderer.image { (ctx) in
            for i in 1...12 {
                let rectOriginX = center.x + (digitDistanceFromCenter - halfFontHeight) * CGFloat(cos((Double.pi/180) * Double((i + 3) * 30) + Double.pi))
                let rectOriginY = center.y + -1 * (digitDistanceFromCenter - halfFontHeight) * CGFloat(sin((Double.pi/180) * Double((i + 3) * 30)))
                let digitRect: CGRect
                let hourDigit = String(i)
                if i < 10 { //digits 1..9
                    digitRect = CGRect(x: rectOriginX, y: rectOriginY, width: halfFontHeight, height: fontHeight)
                } else { //10-12
                    digitRect = CGRect(x: rectOriginX - fontHeight/4, y: rectOriginY, width: fontHeight, height: fontHeight)
                }
                hourDigit.draw(with: digitRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
            }
        }
    }
    
    
    func drawLogo() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: diameter, height: diameter))
        let fontHeight = logoFont.lineHeight
        let halfFontHeight = fontHeight/2
        let center = CGPoint(x: diameter/2, y: diameter/2)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attrs = [NSAttributedString.Key.font: logoFont,
                     NSAttributedString.Key.foregroundColor: logoColor,
                     NSAttributedString.Key.paragraphStyle: paragraphStyle] as [NSAttributedString.Key : Any]
        let originLogo = CGPoint(x: center.x - diameter/4,
                                 y: center.y + diameter/5 - halfFontHeight)
        let logoRect = CGRect(origin: originLogo,
                              size: CGSize(width: diameter/2, height: fontHeight))
        return renderer.image { (ctx) in
            logoText.draw(with: logoRect, options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
    }
}
