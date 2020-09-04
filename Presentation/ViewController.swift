//
//  ViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var sp: FESpiderView!
    @IBOutlet weak var fontt: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let a = FESpiderValue()
        a.value = [0.3,0.4,0.5,0.6,0.7]
        a.fill = UIColor.red.withAlphaComponent(0.6)
        a.color = UIColor.red.withAlphaComponent(0.8)
        let b = FESpiderValue()
        b.value = [0.7,0.6,0.5,0.4,0.3]
        b.fill = UIColor.blue.withAlphaComponent(0.6)
        b.color = UIColor.blue.withAlphaComponent(0.8)
        sp.percentValue = [a,b]
        self.sp .setNeedsDisplay()
     
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    @IBAction func change(_ sender: UISlider) {
        let a = FESpiderValue()
        a.value = [0.3,0.4,0.5,0.6,0.7]
        a.fill = UIColor.red.withAlphaComponent(0.6)
        a.color = UIColor.red.withAlphaComponent(0.8)
        let b = FESpiderValue()
        b.value = [0.7,0.6,0.5,0.4,0.3]
        b.fill = UIColor.blue.withAlphaComponent(0.6)
        b.color = UIColor.blue.withAlphaComponent(0.8)
        sp.percentValue = [a,b]
        sp.rotation = CGFloat(sender.value)
        self.sp .setNeedsDisplay()
    }
}

