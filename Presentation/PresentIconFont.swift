//
//  PresentIconFont.swift
//  Presentation
//
//  Created by hao yin on 2020/8/5.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public struct IconFontLoader{
    static public func registerIconFont(name:String,bundle:Bundle?) {
        let b = bundle ?? Bundle.main
        if let u = b.url(forResource: name, withExtension: "ttf"){
            self.registerIconFont(url: u)
        }
    }
    static public func registerIconFont(url:URL) {
        self.downloadData(url: url) { (data) in
            if let d = data{
                #if DEBUG
                print(self.registerFont(font: d) ?? "iconfont load fail")
                #else
                let _ = self.registerFont(font: d)
                #endif
                
            }
        }
    }
    static public func downloadData(url:URL,callback:@escaping (Data?)->Void) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                callback(data)
            } catch {
                callback(nil)
            }
        }
    }
    static public func registerFont(font:Data)->String?{
        guard let p = CGDataProvider(data: font as CFData) else { return nil }
        guard let gf = CGFont(p) else { return nil }
        if CTFontManagerRegisterGraphicsFont(gf, nil){
            return gf.fullName as String?
        }else{
            return nil
        }
    }
}

public class IconFont{
    public let fontName:String
    public var size:CGFloat
    public var index:UInt16
    init(size:CGFloat,index:UInt16 = 1,name:String  = "iconfont") {
        fontName = name
        self.size = size
        self.index = index
    }
    public var font:CTFont {
        return CTFontCreateWithName(fontName as CFString, size, nil)
    }
    public var iconCount:Int {
        return CTFontGetGlyphCount(font)
    }
    public var path:CGPath?{
        let p = CTFontCreatePathForGlyph(font, CGGlyph(index), nil)
        return p
    }
    public var img:CGImage?{
        guard let path = self.path else { return nil }
        let rect = path.boundingBox;
        
        return PresentImage(size: rect.size).hasAlpha(alpha: true).hasScale(scale: UIScreen.main.scale).draw { (p) in
            var point = CGPoint(x: -rect.origin.x, y: -rect.origin.y)
            CTFontDrawGlyphs(self.font, &self.index, &point, 1, p.context!)
        }
    }
}
