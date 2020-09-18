//
//  File.swift
//  Flex
//
//  Created by hao yin on 2020/9/18.
//

import UIKit
@objc public class FELineChatLayerConfigration : NSObject{
    @objc public var axisXValue:[String] = []
    @objc public var axisYValue:[String] = []
    @objc public var zeroString:String = "0"
    @objc public var axisLineColor:UIColor = UIColor.lightGray
    @objc public var values:[FELineChatValue] = []
    @objc public var backgroundColor:UIColor = UIColor.white;
    @objc public var size:CGSize = CGSize(width: 100, height: 60)
    @objc public var fontsize:CGFloat = 10
}
@objc public class FELineChatValue : NSObject{
    @objc public var valueLineColor:UIColor = UIColor.gray
    @objc public var valueFillColor:UIColor = UIColor.clear
    @objc public var value:[CGFloat] = []
}

public class FELineChatLayer:CALayer{
    
    var leftPadding:CGFloat = 8
    
    var bottomPadding:CGFloat = 8
    
    var rightPadding:CGFloat = 8
    
    var topPadding:CGFloat = 8
    
    var xMax:CGFloat = 0
    
    var yMax:CGFloat = 0
    
    var xStep:CGFloat = 0
    
    var yStep:CGFloat = 0
    
    
    var shapes:[CAShapeLayer] = []
    
    public var configration:FELineChatLayerConfigration?{
        didSet{
            if let s = self.configration{
                self.drawBackground(config: s)
            }
        }
    }
    func drawBackground(config:FELineChatLayerConfigration) {
        if config.axisXValue.count > 0{
            self.leftPadding = self.calcPading(text: config.axisXValue, font: CTFontCreateWithName("" as CFString, config.fontsize, nil)).width + 8
            self.rightPadding = self.leftPadding / 2 + 8;
        }
        if(config.axisYValue.count > 0){
            self.bottomPadding = self.calcPading(text: config.axisYValue, font: CTFontCreateWithName("" as CFString, config.fontsize, nil)).height + 8
            self.topPadding = self.bottomPadding / 2 + 8
        }
        self.yMax = config.size.height - self.bottomPadding - self.topPadding
        self.xMax = config.size.width - self.leftPadding - self.rightPadding
        xStep = (self.xMax) / CGFloat(config.axisXValue.count)
        yStep = (self.yMax) / CGFloat(config.axisYValue.count)
        let p = PresentImage(size: config.size).hasScale(scale: UIScreen.main.scale).hasAlpha(alpha:true).draw { [weak self](p) in
            if let s = self, let ctx = p.context{
                p.context?.setStrokeColor(config.axisLineColor.cgColor)
                p.context?.move(to: CGPoint(x: s.leftPadding, y: s.bottomPadding))
                p.context?.addLine(to: CGPoint(x: s.leftPadding, y: config.size.height - s.topPadding + 8))
                
                p.context?.strokePath()
                p.context?.move(to: CGPoint(x: s.leftPadding - 3, y: config.size.height - s.topPadding + 8))
                p.context?.addLine(to: CGPoint(x: s.leftPadding + 3, y: config.size.height - s.topPadding + 8))
                p.context?.addLine(to: CGPoint(x: s.leftPadding, y: config.size.height - s.topPadding + 16))
                p.context?.setFillColor(config.axisLineColor.cgColor)
                p.context?.fillPath();
                p.context?.move(to: CGPoint(x: s.leftPadding, y: s.bottomPadding))
                p.context?.addLine(to: CGPoint(x: config.size.width - s.rightPadding + 16,y: s.bottomPadding))
                p.context?.strokePath()
                
                p.context?.move(to: CGPoint(x: config.size.width - s.rightPadding + 8,y: s.bottomPadding + 3))
                p.context?.addLine(to: CGPoint(x: config.size.width - s.rightPadding + 8,y: s.bottomPadding - 3))
                p.context?.addLine(to: CGPoint(x: config.size.width - s.rightPadding + 16,y: s.bottomPadding))
                p.context?.setFillColor(config.axisLineColor.cgColor)
                p.context?.fillPath();
                for i in 0 ..< config.values.count {
                    
                    s.loadValues(config: config, index: i, ctx: ctx)
                }
                for i  in 0...config.axisXValue.count {
                    var v = CGPoint(x: s.leftPadding, y: s.bottomPadding)
                    v.x += (s.xStep * CGFloat(i))
                    p.context?.move(to:v)
                    v.y -= 3
                    p.context?.addLine(to:v)
                    p.context?.strokePath()
                    v.y -= 3
                    if(i > 0){
                        let str = config.axisXValue[i - 1].attributeString(color: config.axisLineColor.cgColor, font: CTFontCreateWithName("" as CFString, config.fontsize, nil))
                        str?.draw(ctx: ctx, scale: UIScreen.main.scale, position: v, horizontal: .center, vertical: .trailing, rollOver: false)
                    }
                }
                for i  in 0...config.axisYValue.count {
                    var v = CGPoint(x: s.leftPadding, y: s.bottomPadding)
                    v.y += (s.yStep * CGFloat(i))
                    p.context?.move(to:v)
                    v.x -= 3
                    p.context?.addLine(to:v)
                    p.context?.strokePath()
                    v.x -= 3;
                    if(i > 0){
                        let str = config.axisYValue[i - 1].attributeString(color: config.axisLineColor.cgColor, font: CTFontCreateWithName("" as CFString, config.fontsize, nil))
                        
                        str?.draw(ctx: ctx, scale: UIScreen.main.scale, position: v, horizontal: .trailing, vertical: .center, rollOver: false)
                    }
                }
                if let ctx = p.context{
                    config.zeroString.attributeString(color: config.axisLineColor.cgColor, font: CTFontCreateWithName("" as CFString, config.fontsize, nil))?.draw(ctx: ctx, scale: UIScreen.main.scale, position: CGPoint(x: s.leftPadding, y: s.bottomPadding), horizontal: .trailing, vertical: .trailing, rollOver: false)
                }
            }
        }
        self.contents = p
    }
    func loadValues(config:FELineChatLayerConfigration,index:NSInteger,ctx:CGContext) {
        ctx.saveGState()
        var ps:[CGPoint] = []
        let pth = CGMutablePath()
        for j in 0 ..< config.values[index].value.count {
            let vy = config.values[index].value[j]
            let vx = CGFloat(j) / CGFloat(config.values[index].value.count - 1)
            let p = CGPoint(x: (self.leftPadding + xMax * vx) , y: (self.bottomPadding + yMax * vy))
            
            ps.append(p)
        }
        pth.addLines(between: ps)
        ctx.addPath(pth)
        ctx.setStrokeColor(config.values[index].valueLineColor.cgColor)
        ctx.strokePath()
        ctx.restoreGState()
    }
    func calcPading(text:[String],font:CTFont)->CGSize{
        var max:CGSize = CGSize.zero
        for str in text {
            if let size = str.attributeString(color: UIColor.red.cgColor, font: font)?.bound.size{
                max.width = max.width < size.width ? size.width : max.width
                max.height = max.height < size.height ? size.height : max.width
            }
        }
        return max
    }
    func shaper(index:NSInteger)->CAShapeLayer{
        while index >= self.shapes.count {
            let a = CAShapeLayer()
            self.shapes.append(a)
        }
        return self.shapes[index]
    }
}
