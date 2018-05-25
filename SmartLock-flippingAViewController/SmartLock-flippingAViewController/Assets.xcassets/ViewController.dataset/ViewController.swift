//
//  ViewController.swift
//  Smart-lock-2
//
//  Created by Tadej Strah on 09/02/2018.
//  Copyright © 2018 Tadej Strah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var btnCard: UIButton!
    var isOpen = false
    

    @IBAction func swipeGestureForCardFlip(_ sender: Any) {
        if isOpen {
            isOpen = false
            let image = UIImage(named: "Symbol 3 – 4")
            btnCard.setImage(image, for: .normal)
            UIView.transition(with: btnCard, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        else{
            isOpen = true
            let image = UIImage(named: "Rectangle 3")
            btnCard.setImage(image, for: .normal)
            UIView.transition(with: btnCard, duration: 0.3, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
  //  @IBAction func btnFlip(_ sender: Any) {
//        if isOpen {
//            isOpen = false
//            let image = UIImage(named: "Symbol 3 – 4")
//            btnCard.setImage(image, for: .normal)
//            UIView.transition(with: btnCard, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
//        }
//        else{
//            isOpen = true
//            let image = UIImage(named: "Rectangle 3")
//            btnCard.setImage(image, for: .normal)
//            UIView.transition(with: btnCard, duration: 0.3, options: .transitionFlipFromRight, animations: nil, completion: nil)
//        }
 //   }
    
}

