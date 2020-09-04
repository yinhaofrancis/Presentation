//
//  MVViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/5.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class MVViewController: UIViewController {

//    let tra = DialogAnimation().presentAnimation(during: 0.3, options: .curveEaseInOut) { (da) in
//        da.presented?.view.transform = .identity
//    }.dismissAnimation(during: 0.3, options: .curveEaseInOut) { (da) in
//        da.presented?.view.transform = CGAffineTransform(translationX: 0, y: -UIScreen.main.bounds.size.height)
//    }.beforeAnimation { (da) in
//        da.presented?.view.frame = UIScreen.main.bounds
//        da.presenting?.view.frame = UIScreen.main.bounds
//        da.presented?.view.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.size.height)
//
//    }
//    lazy var trans = {
//        return DialogTransaction<DialogPresentation>(animation: self.tra,style: .custom)
//    }()
//    required init?(coder: NSCoder) {
//        super .init(coder: coder)
//        self.modalPresentationStyle = .custom
//        self.transitioningDelegate = self.trans
//    
//        self.trans.presentation?.maskView = UIView()
//        self.trans.presentation?.maskView?.backgroundColor = UIColor.red
//        
//    }
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//    @IBAction func back(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
}
