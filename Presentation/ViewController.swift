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
        IconFontLoader.registerIconFont(name: "iconfont", bundle: nil)
     
    }

    @IBAction func close(_ sender: Any) {
        if let v = self.storyboard?.instantiateViewController(withIdentifier: "KKK"){
            self.present(v, animated: true, completion: nil)
        }
        self.fontText.text = "\u{e600}\u{e601}\u{e602}\u{e603}\u{e604}\u{e605}\u{e606}\u{e628}"
        let font = UIFont(name: "iconfont", size: 40);
        self.fontText.font = font;
        let f = IconFont(size: 20)
        for i in (1...100) {
            f.index = UInt16(i)
            if let img = f.img{
                let img = UIImage(cgImage: img, scale: UIScreen.main.scale, orientation: .up)
                self.img .addArrangedSubview(UIImageView(image: img))
            }
        }
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}

