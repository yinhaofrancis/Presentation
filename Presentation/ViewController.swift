//
//  ViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fontText: UILabel!
    @IBOutlet weak var fontt: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        IcontFont.registerIconFont(name: "iconfont", bundle: nil)
    }

    @IBAction func close(_ sender: Any) {
        if let v = self.storyboard?.instantiateViewController(withIdentifier: "KKK"){
            self.present(v, animated: true, completion: nil)
        }
        self.fontText.text = "\u{e685}"
        let font = UIFont(name: "iconfont", size: 40);
        self.fontText.font = font;
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

