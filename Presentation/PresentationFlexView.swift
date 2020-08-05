//
//  PresentationFlexView.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

public class PresentationFlexView: UIView {

    public private(set) var managedViews:Array<UIView> = []
    
    public var direction:NSLayoutConstraint.Axis = .horizontal

    public override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    public func addManagedView(view:UIView){
        managedViews.append(view)
        self.addSubview(view)
    }
    
    public func removeManagedView(view:UIView){
        if let idx = self.managedViews.firstIndex(of: view){
            self.managedViews.remove(at: idx)
        }
    }
    private var layoutViews:Array<UIView> {
        return self.managedViews.filter{!$0.isHidden}
    }
//    private var vflAxis:[String]{
//
//    }
}
