//
//  PresentImage.swift
//  Presentation
//
//  Created by hao yin on 2020/8/6.
//  Copyright © 2020 hao yin. All rights reserved.
//
import ImageIO
import QuartzCore
import MobileCoreServices
import CoreText
import UIKit
public final class PresentImage{
    public typealias PresentDrawCall = (PresentImage)->Void
    
    public private(set) lazy var context:CGContext? = {
        let ctx = CGContext(data: nil, width: Int(self.size.width * self.hasScale), height: Int(self.size.height * self.hasScale), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: self.hasAlpha ? CGImageAlphaInfo.premultipliedLast.rawValue : CGImageAlphaInfo.noneSkipLast.rawValue)
        if self.top{
            ctx?.scaleBy(x: 1, y: -1)
            ctx?.translateBy(x: 0, y: -CGFloat(ctx?.height ?? 0))
        }
        ctx?.scaleBy(x: self.hasScale, y: self.hasScale)
        return ctx
    }()
    public private(set) var hasAlpha:Bool = false
    
    public private(set) var hasScale:CGFloat = 1
    
    public private(set) var size:CGSize
    
    public var clearColor:CGColor?
    
    private var top:Bool = false
    
    public init(size:CGSize,topStart:Bool = false){
        self.top = topStart
        self.size = size
    }
    public func hasAlpha(alpha:Bool)->Self {
        self.hasAlpha = alpha
        return self
    }
    public func hasScale(scale:CGFloat)->Self {
        self.hasScale = scale
        return self
    }
    public func draw(call:PresentDrawCall)->CGImage?{
        guard let ctx = self.context else { return nil }
        ctx.clear(CGRect(x: 0, y: 0, width: ctx.width, height: ctx.height))
        if let c = self.clearColor{
            ctx.saveGState()
            ctx.clear(CGRect(x: 0, y: 0, width: ctx.width, height: ctx.height))
            ctx.setFillColor(c)
            ctx.fill(CGRect(x: 0, y: 0, width: ctx.width, height: ctx.height))
            ctx.restoreGState()
        }
        call(self)
        let al = CFAllocatorGetDefault()
        
        guard let image = ctx.makeImage() else { return nil }
        guard let data = CFDataCreateMutable(al?.takeRetainedValue(), 0) else { return image }
        guard let dest = CGImageDestinationCreateWithData(data, kUTTypePNG, 1, nil) else {
            return image
        }
        CGImageDestinationAddImage(dest, image, nil)
        CGImageDestinationFinalize(dest)
        guard let source = CGImageSourceCreateWithData(data, nil) else { return image }
        al?.release()
        return CGImageSourceCreateImageAtIndex(source, 0, nil)
    }
    public func rollOver(){
        self.context?.scaleBy(x: 1, y: -1);
        self.context?.translateBy(x: 0, y: -CGFloat(Int(self.size.height)));
    }
}
public enum drawAlign {
    case leading
    case center
    case trailing
}
extension String{
    public func draw(ctx:CGContext,
                     scale:CGFloat,
                     color:CGColor,
                     font:CTFont,
                     position:CGPoint,
                     horizontal:drawAlign = .center,
                     vertical:drawAlign = .center,
                     rollOver:Bool = true){
        if let att = self.attributeString(color: color, font: font){
            att.draw(ctx: ctx,
                     scale:scale,
                     position: position,
                     horizontal:horizontal,
                     vertical: vertical,
                     rollOver: rollOver)
        }
    }
    public func attributeString(color:CGColor,font:CTFont)->CFAttributedString?{
        let s = NSMutableParagraphStyle()
        s.alignment = .center
        s.lineSpacing = 0
        guard let att = CFAttributedStringCreate(kCFAllocatorDefault, self as CFString, [
            kCTFontAttributeName:font,
            kCTForegroundColorAttributeName:color,
            kCTParagraphStyleAttributeName:s
            ] as CFDictionary) else {
            return nil
        }
        return att
    }
}

extension CFAttributedString {
    
    public var bound:CGRect{
        let size = CTFramesetterSuggestFrameSizeWithConstraints(self.frameset,CFRangeMake(0, CFAttributedStringGetLength(self)), nil, CGSize(width: CGFloat.infinity, height: .infinity), nil)
        return CGRect(x: 0, y: 0, width: size.width, height: size.height)
    }
    public func makeframe(transform:CGAffineTransform)->CTFrame{
        let set = self.frameset
        let path = CGPath(rect: self.bound.applying(transform), transform: nil)
        return CTFramesetterCreateFrame(set, CFRangeMake(0, CFAttributedStringGetLength(self)), path, nil)
    }
    public var frameset:CTFramesetter{
        return CTFramesetterCreateWithAttributedString(self)
    }
    public func draw(ctx:CGContext,scale:CGFloat,position:CGPoint,horizontal:drawAlign,vertical:drawAlign,rollOver:Bool){
        ctx.saveGState()
        var drawPosition = position
        switch horizontal {
        case .center:
            drawPosition.x = position.x - self.bound.width / 2;
            break;
        case .trailing:
            drawPosition.x = position.x - self.bound.width;
            break;
        default:
            drawPosition.x = position.x
            break;
        }
        switch vertical {
        case .center:
            drawPosition.y = position.y - self.bound.height / 2
            break;
        case .trailing:
            drawPosition.y = position.y - self.bound.height
            break;
        default:
            drawPosition.y = position.y - self.bound.origin.y
            break;
        }
        ctx.textPosition = drawPosition;
        if (rollOver){
            ctx.textMatrix = CGAffineTransform(translationX: drawPosition.x, y: drawPosition.y).scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -self.bound.maxY);
        }else{
            ctx.textMatrix = CGAffineTransform(translationX: drawPosition.x, y: drawPosition.y)
        }
        
        
        var frame = self.makeframe(transform: ctx.textMatrix);
        let lines = CTFrameGetLines(frame) as! Array<CTLine>
        if(lines.count > 0){
            var ascent:CGFloat = 0.0
            var descent:CGFloat = 0.0
            var leading:CGFloat = 0.0
            CTLineGetTypographicBounds(lines.first!, &ascent, &descent, &leading)
            if (rollOver){
                ctx.textMatrix = CGAffineTransform(translationX: drawPosition.x, y: drawPosition.y).scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -self.bound.maxY - ascent);
            }else{
                ctx.textMatrix = CGAffineTransform(translationX: drawPosition.x, y: drawPosition.y)
            }
            
            frame = self.makeframe(transform: ctx.textMatrix);
        }
        
        
        CTFrameDraw(frame, ctx)
        ctx.restoreGState()
    }
}
extension CGImage{
    public func draw(ctx:CGContext,rect:CGRect,rollOver:Bool){
        ctx.saveGState()
        ctx.scaleBy(x: 1, y: -1)
        ctx.translateBy(x: 0, y: -rect.minY - rect.maxY)
        ctx.draw(self, in: rect)
        ctx.restoreGState()
    }
}
