//
//  ReviewCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import Cosmos
class ReviewCell: UITableViewCell {

    //MARK: Outlets
    
    @IBOutlet weak var labelUserEmail: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var starsView: CosmosView!
    
    @IBOutlet weak var reviewContent: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(review : Review){
        labelUserEmail.text = review.userEmail
        starsView.rating = review.rating
        dateLabel.text = review.date
        reviewContent.text = review.reviewContent
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
