//
//  ViewController.swift
//  Presentation
//
//  Created by hao yin on 2020/8/1.
//  Copyright © 2020 hao yin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var img: UIStackView!
    @IBOutlet weak var fontText: UILabel!
    @IBOutlet weak var fontt: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
    }

    @IBAction func close(_ sender: Any) {
        let a = PresentImage(size: CGSize(width: 300, height: 300)).hasScale(scale: UIScreen.main.scale)
        a.clearColor = UIColor.red.cgColor
        if let img = a.draw(call: { (pi) in
            let font = CTFontCreateWithName("sys" as CFString, 20, nil)
            #imageLiteral(resourceName: "d").cgImage?.draw(ctx: pi.context!, rect: CGRect(x: 150, y: 150, width: 100, height: 100), rollOver: false)
            "daas你⛰️".draw(ctx: pi.context!, scale:pi.hasScale, color: UIColor.green.cgColor, font:font,position: CGPoint(x: 150, y: 150))
            
        }){
            let imgv = UIImageView(image: UIImage(cgImage: img, scale: UIScreen.main.scale, orientation: .up))
            
            self.img .addArrangedSubview(imgv)
        }
        
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

