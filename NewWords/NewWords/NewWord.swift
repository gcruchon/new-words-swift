//
//  NewWord.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import Foundation

class NewWord {
    
    //MARK: Properties
    
    var word: String
    var definition: String
    
    //MARK: Initialization
    init?(word: String, definition: String) {
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
    
}
