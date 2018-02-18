//
//  NewWordsTests.swift
//  NewWordsTests
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import XCTest
@testable import NewWords

class NewWordsTests: XCTestCase {
    
    //MARK: NewWord Class Tests
    // Confirm that the NewWord initializer returns a NewWord object when passed valid parameters.
    func testNewWordInitializationSucceeds() {
        let normalNewWord = NewWord.init(word: "Word", definition: "word")
        XCTAssertNotNil(normalNewWord)
    }
    
    // Confirm that the NewWord initialier returns nil when passed a negative rating or an empty name.
    func testNewWordInitializationFails() {
        let noWordNewWord = NewWord.init(word: "", definition: "word")
        XCTAssertNil(noWordNewWord)
        
        let noDefinitionNewWord = NewWord.init(word: "word", definition: "")
        XCTAssertNil(noDefinitionNewWord)
        
    }
    
}
