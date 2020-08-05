//
//  DialogAnimation.swift
//  Presentation
//
//  Created by hao yin on 2020/8/4.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public class DialogTransaction<PresentVC:UIPresentationController>:NSObject,UIViewControllerTransitioningDelegate {
    public var presenting:UIViewController?
    public var presented:UIViewController?
    public var source:UIViewController?
    public var presentation:PresentVC?
    public let style:UIModalPresentationStyle
    public var transactionAnimation:DialogAnimation
    public init(animation:DialogAnimation,style:UIModalPresentationStyle? = nil){
        self.style = style ?? .none
        self.transactionAnimation = animation
        super.init()
    }
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if(style == .custom){
            self.presentation = PresentVC(presentedViewController: presented, presenting: presenting)
            return self.presentation
        }
        return nil
    }
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.transactionAnimation.presentAnimation != nil{
            self.transactionAnimation.presented = presented
            self.transactionAnimation.presenting = presenting
            self.transactionAnimation.source = source
            return self.transactionAnimation
        }
        return nil
    }
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if self.transactionAnimation.dismissAnimation != nil{
            self.transactionAnimation.dismissed = dismissed
            return self.transactionAnimation
        }
        return nil
    }
}

public class DialogAnimation:NSObject,UIViewControllerAnimatedTransitioning {
    
    public var dismissed:UIViewController?
    public var presenting:UIViewController?
    public var presented:UIViewController?
    public var source:UIViewController?
    
    private var presentTime:TimeInterval = 0
    private var presentOptions:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: 0)
    var presentAnimation:((DialogAnimation) -> Void)?
    
    private var dissmissTime:TimeInterval = 0
    private var dismissOptions:UIView.AnimationOptions = UIView.AnimationOptions(rawValue: 0)
    var dismissAnimation:((DialogAnimation) -> Void)?
    
    var startAnimation:((DialogAnimation) ->Void)?
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if (self.dismissed != nil) {
            return self.dissmissTime
        }else{
            return self.presentTime
        }
    }
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if((self.dismissed) != nil){
            if let dismiss = self.dismissed?.view{
                transitionContext.containerView.addSubview(dismiss)
            }
        }else{
           if let presented = self.presented?.view{
               transitionContext.containerView.addSubview(presented)
           }
        }
        
        if(self.dismissed != nil) {
            if let a = self.dismissAnimation{
                UIView.animate(withDuration: self.dissmissTime, delay: 0, options: self.dismissOptions, animations: {
                    a(self)
                }) { (b) in
                    transitionContext.completeTransition(b)
                }
            }else{
                transitionContext.completeTransition(true)
            }
        }else{
            if let start = self.startAnimation{
                start(self)
            }
            if let a = self.presentAnimation{
                UIView.animate(withDuration: self.presentTime, delay: 0, options: self.presentOptions, animations: {
                    a(self)
                }) { (b) in
                    transitionContext.completeTransition(b)
                }
            }else{
                transitionContext.completeTransition(true)
            }
        }
    }
    
    public func presentAnimation(during:TimeInterval,options:UIView.AnimationOptions,animations:@escaping (DialogAnimation)->Void)->Self{
        self.presentTime = during
        self.presentOptions = options
        self.presentAnimation = animations
        return self
    }
    public func dismissAnimation(during:TimeInterval,options:UIView.AnimationOptions,animations:@escaping (DialogAnimation)->Void)->Self{
        self.dissmissTime = during
        self.dismissOptions = options
        self.dismissAnimation = animations
        return self
    }
    public func beforeAnimation(animations:@escaping (DialogAnimation)->Void)->Self{
        self.startAnimation = animations
        return self
    }
}
