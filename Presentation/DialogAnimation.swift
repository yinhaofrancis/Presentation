//
//  DialogAnimation.swift
//  Presentation
//
//  Created by hao yin on 2020/8/4.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public class DialogTransaction<PresentVC:UIPresentationController>: NSObject,UIViewControllerTransitioningDelegate {
    public var fromVC:UIViewController?
    public var toVC:UIViewController?
    public var source:UIViewController?
    public var presentation:UIPresentationController?
    public let style:UIModalPresentationStyle
    public init(style:UIModalPresentationStyle? = nil){
        self.style = style ?? .none
        super.init()
    }
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if(style == .custom){
            self.presentation = PresentVC(presentedViewController: presented, presenting: presenting)
            return self.presentation
        }
        return nil
    }
}

public class
