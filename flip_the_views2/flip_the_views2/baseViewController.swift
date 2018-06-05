//
//  ViewController.swift
//  flip_the_views2
//
//  Created by Tadej Strah on 02/06/2018.
//  Copyright © 2018 Tadej Strah. All rights reserved.
//

import UIKit

enum animationState{
    case settingsViewOpened
    case unlockViewOpened
    mutating func changeState(){
        switch self{
        case .settingsViewOpened:
            self = .unlockViewOpened
        case .unlockViewOpened:
            self = .settingsViewOpened
        }
    }
}


class baseViewController: UIViewController {

    var currentState:animationState!
    var animator:UIViewPropertyAnimator?
    var panGestureRecognizer: UIPanGestureRecognizer!
    var animationFraction: CGFloat = 0
    
    @IBOutlet weak var frontSideView: UIView!
    @IBOutlet weak var backSideView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var baseView: baseView!
    
    var rotationWay: Double{
        switch currentState{
        case .settingsViewOpened: return 1.0
        case .unlockViewOpened: return -1.0
        default: return 1.0
        }
    }
    
    func perform3DTransforms(){
        var frontSideViewTransform = CATransform3DIdentity
        frontSideViewTransform.m34 = CGFloat(1.00 / 500 * rotationWay)
        frontSideViewTransform = CATransform3DRotate(frontSideViewTransform, CGFloat.pi, 0, 1, 0)
        frontSideView.layer.transform = frontSideViewTransform
//        let frontViewAnimation = CABasicAnimation(keyPath: "transform")
//        frontViewAnimation.toValue = NSValue(caTransform3D: frontSideViewTransform)
//        frontViewAnimation.duration = 2
//        frontSideView.layer.add(frontViewAnimation, forKey: "transform")
        
        var backSideViewTransform = CATransform3DIdentity
        backSideViewTransform.m34 = CGFloat(1.00 / 500 * rotationWay)
        backSideViewTransform = CATransform3DRotate(backSideViewTransform, CGFloat.pi, 0, 1, 0)
        backSideView.layer.transform = backSideViewTransform

//        let backViewAnimation = CABasicAnimation(keyPath: "transform")
//        backViewAnimation.toValue = NSValue(caTransform3D: backSideViewTransform)
//        backViewAnimation.duration = 2
//        backSideView.layer.add(backViewAnimation, forKey: "transform")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentState = .unlockViewOpened
        panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(flipViews(detectedBy:)))
        baseView.addGestureRecognizer(panGestureRecognizer)
    }

    @objc func flipViews(detectedBy recognizer: UIPanGestureRecognizer){
        guard recognizer.view != nil else {return}
        let translation = recognizer.translation(in: self.view.superview)
        switch recognizer.state {
        case .began:
            startPanning()
        case .changed:
            return
            //flipState = recognizer.translation(in: recognizer.view!).x
            //doTheFlipping(translation: translation )
        case .ended:
            //flipState = CGFloat(recognizer.view!.frame.width)
            let velocity = recognizer.velocity(in: self.view.superview)
           // endAnimation(translation: translation, velocity: velocity)
        default:
            return
        }
    }
    
    func startPanning(){
        
        animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: {
            self.perform3DTransforms()
        })
    }
    
    
    @IBAction func onButtonPressedflipTheViews(_ sender: Any) {
        perform3DTransforms()
        currentState.changeState()
    }
    

    
    
    
    
}

