//
//  File.swift
//  Flex_Example
//
//  Created by hao yin on 2020/7/23.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit


public class FlexView:UIView{
    @objc public var axis:NSLayoutConstraint.Axis = .horizontal{
        didSet{
            switch self.axis {
            case .horizontal:
                self.container.axis = .vertical
            case .vertical:
                self.container.axis = .horizontal
            @unknown default:
                self.container.axis = .vertical
            }
            for stack in self.lines {
                stack.axis = self.axis
            }
            self.layout()
        }
    }
    @objc public var containerAlign:UIStackView.Alignment = .fill{
        didSet{
            self.container.alignment = self.containerAlign;
            self.layout()
        }
    }
    @IBInspectable public var wrap:Bool = false{
        didSet{
            self.layout()
        }
    }
    @IBInspectable public var itemSpaceing:CGFloat = 0{
        didSet{
            self.lines.forEach{$0.spacing = self.itemSpaceing}
        }
    }
    @IBInspectable public var lineSpaceing:CGFloat = 0 {
        didSet{
            self.container.spacing = self.lineSpaceing
        }
    }
    public var scrollView:UIScrollView = UIScrollView()
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.styleConfig()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.styleConfig()
    }
    
    
    
    private var lineAxis:NSLayoutConstraint.Axis{
        if(self.axis == .horizontal){
            return .vertical
        }else{
            return .horizontal
        }
    }
    private var container:UIStackView = UIStackView()
    private var lines:Array<UIStackView> = []
    private var views:Array<UIView> = []
    private var size:CGFloat {
        switch self.axis{
        case .horizontal:
            return self.bounds.size.width
        case .vertical:
            return self.bounds.size.height
        @unknown default:
            return 0
        }
    }
    private func itemSize(stack:UIView)->CGFloat{
        switch self.axis{
        case .horizontal:
            return stack.bounds.size.width
        case .vertical:
            return stack.bounds.size.height
        @unknown default:
            return 0
        }
    }
    private func styleConfig(){
        self.scrollView.showsVerticalScrollIndicator = false;
        self.scrollView.showsHorizontalScrollIndicator = false;
        super.addSubview(self.scrollView)
        self.scrollView.addSubview(self.container)
        let a = [
            self.scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ]
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false;
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.addConstraints(a);
        self.container.axis = self.lineAxis
        
        
        let b = [
            self.container.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.container.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.container.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.container.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
        ]
        self.container.translatesAutoresizingMaskIntoConstraints = false;
        self.scrollView.addConstraints(b);
    }
    public override func addSubview(_ view: UIView) {
        self.views.append(view)
    }
    public func removeView(_ view:UIView) {
        self.views = self.views.filter{$0 == view}
    }
    @objc public func layout(){
        self.lines .forEach { (v) in
            v.removeFromSuperview()
        }
        self.lines.removeAll()
        if(!wrap){
            self.lines.append(UIStackView());
            self.container.spacing = self.lineSpaceing;
            self.lines.first?.spacing = self.itemSpaceing;
            self.lines.forEach { (v) in
                self.container.addArrangedSubview(v)
            }
            self.views .forEach({ (v) in
                self.lines.first?.addArrangedSubview(v)
            })
        }else{
            var stackView:UIStackView?
            var sum:CGFloat = 0
            for v in self.views {
                if(stackView == nil){
                    stackView = self.createLine()
                }
                v.sizeToFit()
                if(stackView?.arrangedSubviews.count != 0){
                    sum += self.itemSpaceing
                }
                sum += self.itemSize(stack: v)
                if(sum > self.size && stackView?.arrangedSubviews.count == 0){
                    self.container.addArrangedSubview(stackView!)
                    self.lines.append(stackView!)
                    stackView = self.createLine()
                    sum = 0
                }else if(sum > self.size){
                    self.container.addArrangedSubview(stackView!)
                    self.lines.append(stackView!)
                    stackView = self.createLine()
                    stackView?.addArrangedSubview(v)
                    sum = self.itemSize(stack: v)
                    if(sum > self.size){
                        self.container.addArrangedSubview(stackView!)
                        self.lines.append(stackView!)
                        stackView = UIStackView()
                        sum = 0
                    }
                }else{
                    stackView?.addArrangedSubview(v)
                }
            }
            if let st = stackView {
                if(!self.lines.contains(st)){
                    self.container.addArrangedSubview(stackView!)
                    self.lines.append(stackView!)
                }
            }
            
        }
    }
    public override func layoutSubviews() {
        self.layout()
    }
    private func createLine()->UIStackView{
        let s = UIStackView()
        s.spacing = self.itemSpaceing
        s.axis = self.axis
        return s
    }
}
