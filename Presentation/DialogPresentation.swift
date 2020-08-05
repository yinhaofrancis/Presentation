//
//  DialogPresentation.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public class DialogPresentation: UIPresentationController,UIAdaptivePresentationControllerDelegate {

    public var maskView:UIView?
    public override func presentationTransitionWillBegin() {
        if let v = self.maskView{
            self.containerView?.addSubview(v)
            v.frame = UIScreen.main.bounds;
        }
        self.beforePresentAnimation()
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            self.afterPresentAnimation()
        }, completion: { (ctx) in
            self.completePresentAnimation()
        })
    }
    public override func presentationTransitionDidEnd(_ completed: Bool) {
        if(!completed){
            self.maskView?.removeFromSuperview()
        }
    }
    public override func dismissalTransitionWillBegin() {
        self.beforeDissmissAnimation()
        self.presentingViewController.transitionCoordinator?.animate(alongsideTransition: { (ctx) in
            self.afterDissmissAnimation()
        }, completion: { (ctx) in
            self.completeDissmissAnimation()
        })
    }
    public func beforePresentAnimation(){
        if let v = self.maskView{
            v.alpha = 0;
        }
    }
    public func afterPresentAnimation(){
        if let v = self.maskView{
            v.alpha = 1;
        }
    }
    public func completePresentAnimation(){
        
    }
    
    public func beforeDissmissAnimation(){
        if let v = self.maskView{
            v.alpha = 1;
        }
    }
    public func afterDissmissAnimation(){
        if let v = self.maskView{
            v.alpha = 0;
        }
    }
    public func completeDissmissAnimation(){
        
    }
    public override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.delegate = self
    }
//    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .overFullScreen;
//    }
}
