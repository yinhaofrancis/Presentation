//
//  FELiveView.swift
//  Presentation
//
//  Created by hao yin on 2020/9/18.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

@objc public class FELineView: UIView {

    @objc public var lineLayer:FELineChatLayer{
        return self.layer as! FELineChatLayer
    }
    public override class var layerClass: AnyClass{
        return FELineChatLayer.self
    }
}
