//
//  NewWordTableViewCell.swift
//  NewWords
//
//  Created by Gilles Cruchon on 04/02/2018.
//  Copyright © 2018 Gilles Cruchon. All rights reserved.
//

import UIKit

class NewWordTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var definitionTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
