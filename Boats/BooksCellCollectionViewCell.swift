//
//  BooksCellCollectionViewCell.swift
//  Boats
//
//  Created by Absolute Mac on 20/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseStorage


protocol bookCellDelegate {
    func moreButtonPress(cellNumr : Int)
}

class BooksCellCollectionViewCell: UICollectionViewCell {

    var delegate : bookCellDelegate?
    var cellNumber : Int?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var viewContinut: UIView!
    
    @IBOutlet weak var viewShadow: UIView!
       @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func moreButtonPressed(_ sender: Any) {
        delegate?.moreButtonPress(cellNumr: cellNumber!)
    }
   
    func configureCell(book : BookLocal,cellNumber : Int){
     
        viewContinut.dropShadow()
        self.nameLabel.text = book.boatModel
        self.startDateLabel.text = book.dateStart
        self.endDateLabel.text = book.dateEnd
        self.cellNumber = cellNumber
//      WebService().iSImageUrlInFirebase(imageURL: book.imageUrl) { (result) in
//       if result {
            WebService().downImage(imgUrl: book.imageUrl) { (img) in
                self.imageView.image = img

        }
//     }
//        }
        

    }

}
