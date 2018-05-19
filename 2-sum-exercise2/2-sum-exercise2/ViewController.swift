//
//  ViewController.swift
//  2-sum-exercise2
//
//  Created by Tadej Strah on 18/05/2018.
//  Copyright © 2018 Tadej Strah. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //vbhjknlm,
        let resultsLabel = UILabel(frame: CGRect(x: 50, y: 50, width: 55, height: 55))
        resultsLabel.text = "neki123" 
        self.view.addSubview(resultsLabel)
        
        let textInput = UITextField(frame: CGRect(x: 100, y: 100, width: 50, height: 50))
        textInput.backgroundColor = UIColor.red
        self.view.addSubview(textInput)
        
        let testniButton = UIButton(frame: CGRect(x: 200, y: 200, width: 50, height: 50))
        testniButton.target(forAction: #selector(updateLabelFromText), withSender: UIButton())
        testniButton.backgroundColor = UIColor.blue
        self.view.addSubview(testniButton)
        
    }

    @objc func updateLabelFromText(){
        print("Neki")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

