//
//  ViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad() 
    }

    @IBAction func close(_ sender: Any) {
        if let v = self.storyboard?.instantiateViewController(withIdentifier: "KKK"){
            self.present(v, animated: true, completion: nil)
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

