//
//  NewWordViewController.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import os.log
import UIKit

class NewWordViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    //MARK: Properties
    @IBOutlet weak var newWordTextField: UITextField!
    @IBOutlet weak var definitionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    /*
     This value is either passed by `NewWordTableViewController` in `prepare(for:sender:)`
     or constructed as part of adding a new word.
     */
    var newWord: NewWord?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newWordTextField.delegate = self
        definitionTextView.delegate = self

        // Set up views if editing an existing NewWord.
        if let newWord = newWord {
            navigationItem.title = newWord.word
            newWordTextField.text   = newWord.word
            definitionTextView.text = newWord.definition
        }
        
         // Enable the Save button only if the text field has a valid New Word.
        saveButton.isEnabled = false
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
        //TODO
        updateSaveButtonState()
        navigationItem.title = getTitleFromField(newWordTextField)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        updateSaveButtonState()
    }
    
    //MARK: UITextViewDelegate
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        updateSaveButtonState()
        return true
    }
    
    //MARK: Navigation
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddNewWordMode = presentingViewController is UINavigationController
        
        if isPresentingInAddNewWordMode {
            dismiss(animated: true, completion: nil)
        } else {
            if let owningNavigationController = navigationController{
                owningNavigationController.popViewController(animated: true)
            } else {
                fatalError("The NewWordViewController is not inside a navigation controller.")
            }
        }
    }
    
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let word = newWordTextField.text ?? ""
        let definition = definitionTextView.text ?? ""
        // Set the NewWord to be passed to NewWordTableViewController after the unwind segue.
        newWord = NewWord(word: word, definition: definition)
    }

    //MARK: Actions
    
    
    //MARK: Private methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let word = newWordTextField.text ?? ""
        let definition = definitionTextView.text ?? ""
        
        saveButton.isEnabled = !word.isEmpty && !definition.isEmpty
    }
    
    private func getTitleFromField(_ textField: UITextField) -> String{
        let title = textField.text ?? ""
        if(title.isEmpty) {
            return "Add a new word"
        } else {
            return title;
        }
    }
}

