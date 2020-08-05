//
//  PresentIconFont.swift
//  Presentation
//
//  Created by hao yin on 2020/8/5.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public struct IcontFont{
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

public class IconFontLayer:CALayer{
    public var fontName:String = "iconfont"
    public var fontSize:CGFloat = 40;
    private var font:UIFont{
        return UIFont(name: fontName, size: fontSize) ?? UIFont.systemFont(ofSize: self.fontSize)
    }
    
}
