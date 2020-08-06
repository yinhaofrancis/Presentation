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

public final class PresentImage{
    public typealias PresentDrawCall = (PresentImage)->Void
    
    public private(set) lazy var context:CGContext? = {
        return CGContext(data: nil, width: Int(self.size.width * self.hasScale), height: Int(self.size.height * self.hasScale), bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: self.hasAlpha ? CGImageAlphaInfo.premultipliedLast.rawValue : CGImageAlphaInfo.noneSkipLast.rawValue)
    }()
    public private(set) var hasAlpha:Bool = false
    
    public private(set) var hasScale:CGFloat = 1
    
    public private(set) var size:CGSize
    
    public init(size:CGSize){
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
        ctx.scaleBy(x: self.hasScale, y: self.hasScale)
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
}
