//
//  Chat&BooksCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

protocol ChatBookDelegate {
    func bookPress()
    func chatPress()
}

class Chat_BooksCell: UITableViewCell {
   
    var delegate : ChatBookDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func bookBtnPressed(_ sender: Any) {
        delegate?.bookPress()
    }
    
    @IBAction func chatBtnPressed(_ sender: Any) {
        delegate?.chatPress()
    }
    
}
