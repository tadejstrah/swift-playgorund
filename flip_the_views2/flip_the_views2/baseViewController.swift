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
    var didChangeZIndexes: Bool = false
    
    var animationFraction: CGFloat = 0{
        didSet{
            statusLabel.text = animationFraction.description
            if animationFraction > 1/2, !didChangeZIndexes {
                if backSideView.layer.zPosition == 1{
                    backSideView.layer.zPosition = 0
                }
                else{
                    backSideView.layer.zPosition = 1
                }
                if frontSideView.layer.zPosition == 1{
                    frontSideView.layer.zPosition = 1
                }
                else{
                    frontSideView.layer.zPosition = 0
                }
            didChangeZIndexes = true
            }
        }
    }
    
    @IBOutlet weak var frontSideView: UIView!
    @IBOutlet weak var backSideView: UIView!
    @IBOutlet weak var statusLabel: UILabel!{
        didSet{
            statusLabel.layer.zPosition = 3
        }
    }
    
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
    
    var frontSideViewZIndex: CGFloat = 0
    var backSideViewZIndex: CGFloat = 0
    
    
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
        let velocity = recognizer.velocity(in: self.view.superview)
        switch recognizer.state {
        case .began:
            startPanning()
        case .changed:
            doTheFlipping(translation: translation, velocity: velocity )
        case .ended:
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
    
    func doTheFlipping(translation: CGPoint, velocity:CGPoint){
        if let animator = self.animator {
            var progress:CGFloat = 0
            progress = abs(translation.x / self.view.frame.width * 2)
            switch currentState{
            case .settingsViewOpened:
                print("settings view opened, translation: \(translation.x)")
                if translation.x < 0{
                    animator.isReversed = false
                }
                else{
                    animator.isReversed = true
                    }
            case .unlockViewOpened:
                print("unlock view opened, translation: \(translation.x)")
                if translation.x < 0{
                    animator.isReversed = true
                }
                else{
                    animator.isReversed = false
                }
            default: animator.isReversed = true

        }
            print(animator.isReversed)
            animator.fractionComplete = progress
            animationFraction = animator.fractionComplete
        }
    }
    
    
    
    func endAnimation (translation:CGPoint, velocity:CGPoint) {
        
        if let animator = self.animator {
            panGestureRecognizer.isEnabled = false
            
            animationFraction = animator.fractionComplete
            
            switch currentState {
            case .unlockViewOpened:
                if animationFraction >= 1 / 2 {
                    animator.isReversed = false
                    animator.addCompletion ({ (position: UIViewAnimatingPosition) in
                        self.currentState = .settingsViewOpened
                        self.panGestureRecognizer.isEnabled = true
                    })
                } else {
                    animator.isReversed = true
                    animator.addCompletion ({ (position: UIViewAnimatingPosition) in
                        self.currentState = .unlockViewOpened
                        self.panGestureRecognizer.isEnabled = true
                    })
                animator.isReversed = false
                }
            case .settingsViewOpened:
                if animationFraction >= 1 / 2  {
                    animator.isReversed = false
                    animator.addCompletion ({ (position: UIViewAnimatingPosition) in
                        self.currentState = .unlockViewOpened
                        self.panGestureRecognizer.isEnabled = true
                    })
                } else {
                    animator.isReversed = true
                    animator.addCompletion ({ (position: UIViewAnimatingPosition) in
                        self.currentState = .settingsViewOpened
                        self.panGestureRecognizer.isEnabled = true
                    })
                animator.isReversed = true
                }
            default:
                print("Unknown state")
            }

            let vector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
            let spgingParameters = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: vector)
            animator.continueAnimation(withTimingParameters: spgingParameters, durationFactor: 1)
            print("neki \(animator.isReversed)")
            didChangeZIndexes = false
        }
    }
}

