//
//  ViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var line: FELineView!
    @IBOutlet weak var fontt: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
     
    }
    @IBAction func po(_ sender: UISlider) {
        let f = FELineChatLayerConfigration()
        f.axisXValue = ["0","PI"]
        f.axisYValue = ["0.5","1"]
        f.zeroString = "0"
        f.backgroundColor = UIColor.green
        f.axisLineColor = UIColor.systemGreen
        
        let v = FELineChatValue()
        
        for i in 0 ..< 1000 {
            v.value.append((sin(CGFloat(i) / 600 * CGFloat(sender.value)) * cos(CGFloat(i) / 600 * CGFloat(sender.value)) + 1) / 2)
        }
        
        v.valueLineColor = UIColor.systemPink;
        f.values.append(v)
        f.size = CGSize(width: 300, height: 180)
        self.line.lineLayer.configration = f;
    }
}

