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
    var animationFraction: CGFloat = 0{
        didSet{
            statusLabel.text = animationFraction.description
        }
    }
    
    @IBOutlet weak var frontSideView: UIView!
    @IBOutlet weak var backSideView: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet var baseView: UIView!
    
    var rotationWay: Double = 1.0
    
    var frontSideViewRotationState: CGFloat{
        switch currentState{
        case .settingsViewOpened: return CGFloat(0)
        case .unlockViewOpened: return CGFloat.pi
        default: return 1
        }
    }
    var backSideViewRotationState: CGFloat{
        switch currentState{
        case .settingsViewOpened: return CGFloat(0)
        case .unlockViewOpened: return CGFloat.pi
        default: return 1
        }
    }
    
    func perform3DTransforms(){
        var frontSideViewTransform = CATransform3DIdentity
        frontSideViewTransform.m34 = CGFloat(1.00 / 500 * rotationWay)
        frontSideViewTransform = CATransform3DRotate(frontSideViewTransform, frontSideViewRotationState, 0, 1, 0)
        frontSideView.layer.transform = frontSideViewTransform
        var backSideViewTransform = CATransform3DIdentity
        backSideViewTransform.m34 = CGFloat(1.00 / 500 * rotationWay)
        backSideViewTransform = CATransform3DRotate(backSideViewTransform, backSideViewRotationState, 0, 1, 0)
        backSideView.layer.transform = backSideViewTransform
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
            doTheFlipping(translation: translation )
        case .ended:
            let velocity = recognizer.velocity(in: self.view.superview)
            endAnimation(translation: translation, velocity: velocity)
        default:
            return
        }
    }
    
    func startPanning(){
        panGestureRecognizer.isEnabled = true
        animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: {
            self.perform3DTransforms()
        })
        animationFraction = animator!.fractionComplete
    }
    
    func doTheFlipping(translation: CGPoint){
        if let animator = self.animator {
            var progress:CGFloat = 0
            progress = abs(translation.x / self.view.frame.width * 2)
            if (translation.x < 0){
                rotationWay = -1.0
            }
            else{
                rotationWay = 1.0
            }
            animator.fractionComplete = progress
            animationFraction = animator.fractionComplete
        }
    }
    
    
    
    func endAnimation (translation:CGPoint, velocity:CGPoint) {
        
        if let animator = self.animator {
            panGestureRecognizer.isEnabled = false
            
            animationFraction = animator.fractionComplete
            
            switch currentState{
            case .settingsViewOpened:
                    perform3DTransforms()
                    panGestureRecognizer.isEnabled = true
            case .unlockViewOpened:
                    perform3DTransforms()
                    panGestureRecognizer.isEnabled = true
            default:
                print("wuht??")
            }
            
            let vector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
            let spgingParameters = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: vector)
            animator.continueAnimation(withTimingParameters: spgingParameters, durationFactor: 1)
            currentState.changeState()

        }
    }
    

    
    
    
}

