//
//  MyBoat_ImagesCell.swift
//  Boats
//
//  Created by Absolute Mac on 25/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

protocol MyBoat_ImagesCellDelegate {

}

class MyBoat_ImagesCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var cellIndex : IndexPath?
    var delegate : MyBoat_ImagesCellDelegate?
    var URL : String?
    var urlsCount: Int?
    var isTarget: Bool?
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        let tap = UIGestureRecognizer(target: self, action: #selector(handleTap))
//        imageView.addGestureRecognizer(tap)
    }
    
//    func handleTap(){
//        
//    }
    
    override var isSelected: Bool{
        didSet{
            if self.isSelected
            {
                //This block will be executed whenever the cell’s selection state is set to true (i.e For the selected cell)

                imageView.alpha = 0.5
           
            }
            else
            {
                //This block will be executed whenever the cell’s selection state is set to false (i.e For the rest of the cells)

             imageView.alpha = 1
            }
        }
    }
    
    func configureCell(cellIndex index: IndexPath,imageUrl url: String,sender myDelegate: MyBoat_ImagesCellDelegate,numberOfCell: Int){
        cellIndex = index
        delegate = myDelegate
        URL = url
        urlsCount = numberOfCell
        if let imageUrl = URL{
            
            WebService().downImage(imgUrl: imageUrl) { (img) in
                self.imageView.image = img
            }
            
        }
        
        
    
    
    }
    


}
