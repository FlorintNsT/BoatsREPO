//
//  CollectionViewCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var boatImage: UIImageView!
    
    @IBOutlet weak var grayVIew: UIView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var modelLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
   
    @IBOutlet weak var typeLabel: UILabel!
    
    @IBOutlet weak var ContinutView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    func configureCell(imgUrl : String,pret: String ,model : String,aval : String,location : String , type : String){
        ContinutView.dropShadow()
        self.priceLabel.text = pret
        self.modelLabel.text = model
        self.locationLabel.text = location
      //  self.typeLabel.text = type
      
        WebService().downImage(imgUrl: imgUrl) { (img) in
            self.boatImage.image = img
            
            if aval == "No"{
                self.grayVIew.isHidden = false
            }
        }
    }
    
}

