//
//  NewWordTableViewController.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import os.log
import UIKit

class NewWordTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var newWords = [NewWord]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved words, otherwise load sample data.
        if let savedNewWords = loadNewWords() {
            newWords += savedNewWords
        } else {
            // Load the sample data.
            loadSampleNewWords()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newWords.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NewWordTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewWordTableViewCell  else {
            fatalError("The dequeued cell is not an instance of NewWordTableViewCell.")
        }
        // Configure the cell...
        let newWord = newWords[indexPath.row]
        cell.wordLabel.text = newWord.word
        cell.definitionTextView.text = newWord.definition

        return cell
    }


    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            newWords.remove(at: indexPath.row)
            saveNewWords()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            case "AddItem":
                os_log("Adding a new word.", log: OSLog.default, type: .debug)
            
            case "ShowDetail":
                guard let newWordDetailViewController = segue.destination as? NewWordViewController else {
                    fatalError("Unexpected destination: \(segue.destination)")
                }
                
                guard let selectedNewWordCell = sender as? NewWordTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedNewWordCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedNewWOrd = newWords[indexPath.row]
                newWordDetailViewController.newWord = selectedNewWOrd
            default:
                fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Actions
    
    @IBAction func unwindToNewWordList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? NewWordViewController, let newWord = sourceViewController.newWord {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                
                // Update selected word
                newWords[selectedIndexPath.row] = newWord
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
                
            } else {
                
                // Add a new word.
                let newIndexPath = IndexPath(row: newWords.count, section: 0)
                newWords.append(newWord)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            saveNewWords()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleNewWords() {
        guard let newWord1 = NewWord(word: "dictionary", definition: "A book that contains a list of words in alphabetical order and that explains their meanings, or gives a word for them in another language.") else {
            fatalError("Unable to instantiate 'dictionary'")
        }
        guard let newWord2 = NewWord(word: "new", definition: "Recently created or having started to exist recently.") else {
            fatalError("Unable to instantiate 'new'")
        }
        guard let newWord3 = NewWord(word: "word", definition: " A single unit of language that has meaning and can be spoken or written.") else {
            fatalError("Unable to instantiate 'word'")
        }
        newWords += [newWord1, newWord2, newWord3]
    }
    
    private func saveNewWords() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newWords, toFile: NewWord.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("New words successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save new words...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadNewWords() -> [NewWord]? {
        return NSKeyedUnarchiver.unarchiveObject(withFile: NewWord.ArchiveURL.path) as? [NewWord]
    }
}
