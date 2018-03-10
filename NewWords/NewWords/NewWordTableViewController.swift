//
//  NewWordTableViewController.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import os.log
import RxCocoa
import RxSwift
import UIKit

class NewWordTableViewController: UITableViewController {
    
    //MARK: Properties
    
    let newWords: Variable<[NewWord]> = Variable([])
    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(WordTableViewCell.self, forCellReuseIdentifier: WordTableViewCell.Identifier)
        tableView.delegate = nil
        tableView.dataSource = nil
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        setupCellConfiguration()
        setupCellClick()
        setupCellDelete()

        
        // Use the edit button item provided by the table view controller.
        navigationItem.leftBarButtonItem = editButtonItem

        // Load any saved words, otherwise load sample data.
        if let savedNewWords = loadNewWords() {
            newWords.value += savedNewWords
        } else {
            // Load the sample data.
            loadSampleNewWords()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

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
                
                guard let selectedNewWordCell = sender as? WordTableViewCell else {
                    fatalError("Unexpected sender: \(String(describing: sender))")
                }
                
                guard let indexPath = tableView.indexPath(for: selectedNewWordCell) else {
                    fatalError("The selected cell is not being displayed by the table")
                }
                
                let selectedNewWOrd = newWords.value[indexPath.row]
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
                newWords.value[selectedIndexPath.row] = newWord
            } else {
                // Add a new word.
                newWords.value.append(newWord)
            }
            saveNewWords()
        }
    }
    
    //MARK: Rx Setup
    private func setupCellConfiguration() {
        newWords.asObservable()
            .bind(to:tableView
                .rx
                .items(cellIdentifier: WordTableViewCell.Identifier, cellType: WordTableViewCell.self)) { row, newWord, cell in
                    cell.backgroundColor = UIColor(named: "red")
                    cell.configureWithNewWord(newWord: newWord)
            }
            .disposed(by: disposeBag)
    }
    
    private func setupCellClick() {
        tableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.performSegue(withIdentifier: "ShowDetail", sender: self?.tableView.cellForRow(at: indexPath))
            })
            .disposed(by: disposeBag)
    }
    
    private func setupCellDelete() {
        tableView.rx.itemDeleted
            .subscribe(onNext: { [weak self] indexPath in
                self?.newWords.value.remove(at: indexPath.row)
                self?.saveNewWords()
            })
            .disposed(by: disposeBag)
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
        newWords.value += [newWord1, newWord2, newWord3]
    }
    
    private func saveNewWords() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(newWords.value, toFile: NewWord.ArchiveURL.path)
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
