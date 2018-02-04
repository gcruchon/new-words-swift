//
//  ViewController.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var newWordTextField: UITextField!
    @IBOutlet weak var newWordLabel: UILabel!
    @IBOutlet weak var newWordDefiniton: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newWordTextField.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        newWordLabel.text = textField.text
    }

    //MARK: Actions
}

