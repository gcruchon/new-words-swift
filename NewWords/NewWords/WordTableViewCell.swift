//
//  WordTableViewCell.swift
//  NewWords
//
//  Created by Gilles Cruchon on 21/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import os.log
import UIKit
import SnapKit

class WordTableViewCell: UITableViewCell {
    
    let MARGIN = 20

    static let Identifier = "WordTableViewCell"
    lazy var wordLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
        return label
    }()
    
    lazy var definitionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureSubviews()
    }
    
    // We won’t use this but it’s required for the class to compile
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setEditing(_ editing: Bool, animated: Bool){
        super.setEditing(editing, animated: animated)
        
        var offset = 0;
        if(editing){
            offset = 30
        }
        UIView.animate(withDuration: 0.3) {
            self.wordLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(self).offset(self.MARGIN + offset)
            }
            self.definitionLabel.snp.updateConstraints { (make) -> Void in
                make.left.equalTo(self).offset(self.MARGIN + offset)
            }
            self.layoutIfNeeded()
        }
    }
    
    func configureSubviews() {
        self.addSubview(self.wordLabel)
        self.addSubview(self.definitionLabel)
        
        wordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(MARGIN)
            make.left.equalTo(self).offset(MARGIN)
            make.right.equalTo(self).offset(-1 * MARGIN)
        }
        
        definitionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(wordLabel.snp.bottom).offset(15)
            make.left.equalTo(self).offset(MARGIN)
            make.right.equalTo(self).offset(-1 * MARGIN)
            make.bottom.equalTo(self).offset(-1 * MARGIN)
        }
    }
    
    
    func configureWithNewWord(newWord: NewWord) {
        wordLabel.text = newWord.word
        definitionLabel.text = newWord.definition
    }


}
