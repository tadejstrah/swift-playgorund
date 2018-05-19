//
//  ViewController.swift
//  SmartLock-flippingAViewController
//
//  Created by Tadej Strah on 19/05/2018.
//

import UIKit

enum AnimationState{
    case settingsOpened
    case unlockViewOpened
}

//@IBDesignable
class ViewController: UIViewController {

    var animator:UIViewPropertyAnimator?
    var currentState:AnimationState!
    
    var settingsViewZPosition: CGFloat = 0
    var unlockViewZPosition: CGFloat = 1
    
    var settingsViewAlpha: CGFloat = 0
    var unlockViewAlpha: CGFloat = 1
    
    var settingsView3DRotation: CGFloat = CGFloat.pi
    var unlockView3DRotation: CGFloat = CGFloat(0)
    
    var matriceForRotationUnlockView: CGFloat = -1
    var matriceForRotationSettingsView: CGFloat = -1
    
    
    var panRecognizer:UIPanGestureRecognizer!

    
    
    @IBOutlet weak var unlockView: UIView!
    @IBOutlet weak var settingsView: UITableView!
    
    @IBOutlet weak var BaseView: BaseView!{
        didSet{
        }
    }
    
    
    @IBOutlet weak var testLabel2: UILabel! {
        didSet{
            testLabel2.text = "neki"
        }
    }
    override func viewDidLoad() {
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(flipViews(detectedBy:)))
        BaseView.addGestureRecognizer(panRecognizer)

        super.viewDidLoad()
        
        currentState = .unlockViewOpened

    }
  
    
    var flipState: CGFloat = 0{
        didSet{
            testLabel2.text = flipState.description
        }
    }
    
    @objc func flipViews(detectedBy recognizer: UIPanGestureRecognizer){
        guard recognizer.view != nil else {return}
        let translation = recognizer.translation(in: self.view.superview)
        switch recognizer.state {
        case .began:
            startPanning()
        case .changed:
            flipState = recognizer.translation(in: recognizer.view!).x
            doTheFlipping(translation: translation )
        case .ended:
            flipState = CGFloat(recognizer.view!.frame.width)
            let velocity = recognizer.velocity(in: self.view.superview)
            endAnimation(translation: translation, velocity: velocity)
        default:
            return
        }
    }
    
    func startPanning() {

        switch currentState {
        case .unlockViewOpened:
            settingsViewZPosition = 1
            unlockViewZPosition = 0
            settingsView3DRotation = CGFloat.pi
            unlockView3DRotation = CGFloat.pi
            currentState = .settingsOpened
            matriceForRotationUnlockView = 1
            matriceForRotationSettingsView = 1
            
        case .settingsOpened:
            settingsViewZPosition = 0
            unlockViewZPosition = 1
            settingsView3DRotation = 0
            unlockView3DRotation = 0
            currentState = .unlockViewOpened
            matriceForRotationUnlockView = -1
            matriceForRotationSettingsView = -1
            
        default:
            print("unknown state")
        }
  
        animator = UIViewPropertyAnimator(duration: 1, dampingRatio: 0.8, animations: {
    
            var rotationWithPerspectiveForUnlockVIew = CATransform3DIdentity;
            rotationWithPerspectiveForUnlockVIew.m34 = self.matriceForRotationUnlockView/500.0/2/2
            rotationWithPerspectiveForUnlockVIew = CATransform3DRotate(rotationWithPerspectiveForUnlockVIew, self.unlockView3DRotation, 0, 1, 0);
           
            var rotationWithPerspectiveForSettingsView = CATransform3DIdentity;
            rotationWithPerspectiveForSettingsView.m34 = self.matriceForRotationSettingsView/500.0/2/2
            rotationWithPerspectiveForSettingsView = CATransform3DRotate(rotationWithPerspectiveForSettingsView, self.settingsView3DRotation, 0, 1, 0);
            
            self.unlockView.layer.transform = rotationWithPerspectiveForUnlockVIew
            self.settingsView.layer.transform = rotationWithPerspectiveForSettingsView
  
        })
    }
    
    
    func doTheFlipping(translation: CGPoint){
        if let animator = self.animator {
            var progress:CGFloat = 0
            
            switch currentState {
            case .unlockViewOpened, .settingsOpened:
                progress = translation.x / self.view.frame.width
                if (Float(progress) > 1/2){
                    settingsView.layer.zPosition = settingsViewZPosition
                    unlockView.layer.zPosition = unlockViewZPosition
                }
                print(progress)
            default:
                print("unknown state")
            }
            animator.fractionComplete = progress
        }
    }
    
    
        func endAnimation (translation:CGPoint, velocity:CGPoint) {
    
            if let animator = self.animator {
                panRecognizer.isEnabled = false
    
                switch currentState{
                case .settingsOpened:
                    var rotationWithPerspectiveForUnlockVIew = CATransform3DIdentity;
                    rotationWithPerspectiveForUnlockVIew.m34 = self.matriceForRotationUnlockView/500.0/2/2
                    rotationWithPerspectiveForUnlockVIew = CATransform3DRotate(rotationWithPerspectiveForUnlockVIew, self.unlockView3DRotation, 0, 1, 0);
                    animator.addCompletion({ (position:UIViewAnimatingPosition) in
                        self.panRecognizer.isEnabled = true
                        
                                        })
                    
                case .unlockViewOpened:
                    var rotationWithPerspectiveForSettingsView = CATransform3DIdentity;
                    rotationWithPerspectiveForSettingsView.m34 = self.matriceForRotationSettingsView/500.0/2/2
                    rotationWithPerspectiveForSettingsView = CATransform3DRotate(rotationWithPerspectiveForSettingsView, self.settingsView3DRotation, 0, 1, 0);
                    animator.addCompletion({ (position:UIViewAnimatingPosition) in
                        self.panRecognizer.isEnabled = true
                    })
                default:
                    print("wuht??")
                }
                
                let vector = CGVector(dx: velocity.x / 100, dy: velocity.y / 100)
                let spgingParameters = UISpringTimingParameters(dampingRatio: 0.5, initialVelocity: vector)
    
                animator.continueAnimation(withTimingParameters: spgingParameters, durationFactor: 1)
            }
        }
    
    
    
}

