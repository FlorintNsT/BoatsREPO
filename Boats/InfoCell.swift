//
//  InfoCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class InfoCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configureCell(name :String , date: String){
        nameLabel.text = name
        dateLabel.text = date
    }
}
