//
//  ImageCollectionCell.swift
//  Boats
//
//  Created by Absolute Mac on 19/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell(image : UIImage){
        imageView.image = image
    }
}
