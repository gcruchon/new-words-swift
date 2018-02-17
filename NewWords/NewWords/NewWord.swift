//
//  NewWord.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import os.log
import Foundation

class NewWord: NSObject, NSCoding {
    
    //MARK: Properties
    
    var word: String
    var definition: String
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("newWords")
    
    //MARK: Types
    struct PropertyKey {
        static let word = "word"
        static let definition = "definition"
    }
    
    //MARK: Initialization
    init?(word: String, definition: String) {
        //super.init()
        
        // Initialization should fail if there is no word or no definition.
        guard !word.isEmpty else {
            return nil
        }
        guard !definition.isEmpty else {
            return nil
        }
        // Initialize stored properties.
        self.word = word
        self.definition = definition
    }
    
    //MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(word, forKey: PropertyKey.word)
        aCoder.encode(definition, forKey: PropertyKey.definition)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The 'word' property is required. If we cannot decode a name string, the initializer should fail.
        guard let word = aDecoder.decodeObject(forKey: PropertyKey.word) as? String else {
            os_log("Unable to decode the 'word' for a New Word object.", log: OSLog.default, type: .debug)
            return nil
        }
        // The 'definition' property is required. If we cannot decode a name string, the initializer should fail.
        guard let definition = aDecoder.decodeObject(forKey: PropertyKey.definition) as? String else {
            os_log("Unable to decode the 'definition' for a New Word object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(word: word, definition: definition)
    }
}
