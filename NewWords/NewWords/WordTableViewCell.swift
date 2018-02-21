//
//  WordTableViewCell.swift
//  NewWords
//
//  Created by Gilles Cruchon on 21/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import UIKit
import SnapKit

class WordTableViewCell: UITableViewCell {

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
    
    func configureSubviews() {
        self.addSubview(self.wordLabel)
        self.addSubview(self.definitionLabel)
        
        wordLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(20)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
        
        definitionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(wordLabel.snp.bottom).offset(15)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
            make.bottom.equalTo(self).offset(-20)
        }
    }


}
