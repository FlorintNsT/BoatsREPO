//
//  MoreReviewCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

protocol MoreReviewButtonDelegate {
    func btnPress()
}
class MoreReviewCell: UITableViewCell {

    var delegate : MoreReviewButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func moreBtnPressed(_ sender: Any) {
        delegate?.btnPress()
    }
}
