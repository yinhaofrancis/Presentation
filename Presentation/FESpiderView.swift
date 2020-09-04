//
//  FESpiderView.swift
//  Presentation
//
//  Created by hao yin on 2020/9/4.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit
public class FESpiderValue:NSObject{
    var value:[CGFloat] = []
    var color:UIColor = UIColor.white
    var fill:UIColor = UIColor.white
    var index:Int = 0
}
public class FESpiderView:UIView {
    public var titles:[String] = ["Rating","Rating","Rating","Rating","Rating"]
    @IBInspectable public var step:Int = 5
    @IBInspectable public var rotation:CGFloat = -CGFloat.pi / 2
    @IBInspectable public var lineColor:UIColor = UIColor.black
    @IBInspectable public var textColor:UIColor = UIColor.red
    @IBInspectable public var fontSize:CGFloat = 10
    @IBInspectable public var padingX:CGFloat = 60
    var layers:[CAShapeLayer] = []
    public var percentValue:[FESpiderValue] = []
    func drawSpider(ctx:CGContext,frame:CGRect){
        ctx.saveGState()
        let perangle = CGFloat.pi * 2 / CGFloat(titles.count)
        ctx.translateBy(x: frame.midX, y: frame.midY)
        ctx.setLineWidth(1)
        ctx.setStrokeColor(self.lineColor.cgColor)
        ctx.saveGState()
        ctx.rotate(by: rotation)
        for _ in 0..<titles.count {
            ctx.move(to: .zero)
            ctx.addLine(to: CGPoint(x: frame.size.width / 2,y:0))
            ctx.rotate(by: perangle)
        }
        ctx.restoreGState()
        var a = CGAffineTransform(rotationAngle: rotation);
        for i in titles {
            let p = CGPoint(x: frame.size.width / 2 + 20,y:0).applying(a)
            i.draw(ctx: ctx, scale: UIScreen.main.scale, color: self.textColor.cgColor, font: CTFontCreateWithName("" as CFString, fontSize, nil), position: p)
            a = a.rotated(by: perangle)
        }
        for i in 1 ... self.step {
            ctx.saveGState()
            ctx.rotate(by: rotation)
            for _ in 0 ..< titles.count {
                ctx.move(to: CGPoint(x: frame.width / 2 / CGFloat(self.step) * CGFloat(i)  , y: 0))
                ctx.rotate(by: perangle)
                ctx.addLine(to: CGPoint(x: frame.width / 2 / CGFloat(self.step) * CGFloat(i)  , y: 0))
            }
            ctx.restoreGState()
        }
        ctx.strokePath()
        ctx.restoreGState()
        
    
        for i in 0..<self.percentValue.count {
            let value = self.percentValue[i]
            let layer = self.createLayer(value: i)
            layer.path = self.createShape(values:value.value , max: frame.width / 2, rotation: self.rotation, perangle: perangle, space: self.bounds)
            layer.frame = self.bounds
            layer.fillColor = value.fill.cgColor
            layer.strokeColor = value.color.cgColor
        }
    }
    public override func draw(_ rect: CGRect) {
        self.drawSpider(ctx: UIGraphicsGetCurrentContext()!, frame: rect.insetBy(dx: self.padingX, dy: self.padingX))
    }
    public func createLayer(value:Int)->CAShapeLayer{
        if layers.count > value{
            return layers[value]
        }else{
            let layer = CAShapeLayer()
            layers.append(layer)
            layer.lineWidth = 1;
            self.layer.addSublayer(layer)
            return layer
        }
    }
    func createShape(values:[CGFloat],max:CGFloat,rotation:CGFloat,perangle:CGFloat,space:CGRect)->CGPath{
        var i = 0
        let path = CGMutablePath()
        for v in values {
            let trans = CGAffineTransform(translationX: space.midX, y: space.midY).rotated(by: CGFloat(i) * perangle).rotated(by: rotation)
            if i == 0{
                let p = CGPoint(x: v * max, y: 0)
                path.move(to: p,transform: trans)
            }else{
                let p = CGPoint(x: v * max, y: 0)
                path.addLine(to: p,transform: trans)
            }
            i += 1
        }
        path.closeSubpath()
        
        return path
    }
}
