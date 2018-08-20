//
//  PopOverCell.swift
//  Boats
//
//  Created by Absolute Mac on 18/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class PopOverCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(withText context : String){
        label.text = context
    }
}
