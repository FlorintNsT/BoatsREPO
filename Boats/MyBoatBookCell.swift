//
//  MyBoatBookCell.swift
//  Boats
//
//  Created by Absolute Mac on 20/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
class MyBoatBookCell: UICollectionViewCell {

    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var ClientTxt: UILabel!
    
    @IBOutlet weak var startPTxt: UILabel!
    
    @IBOutlet weak var endPTxt: UILabel!
    
    @IBOutlet weak var boatModelLabel: UILabel!
    var boatKey : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(book : BookLocal){
        self.ClientTxt.text = book.Client
        self.startPTxt.text = book.dateStart
        self.endPTxt.text = book.dateEnd
        self.boatModelLabel.text = book.boatModel
        boatKey = book.BookKey
        
        WebService().downImage(imgUrl: book.imageUrl) { (img) in
            self.imageView.image = img
            
        }
       
        
    
    }
    
//    @IBAction func contactButtonPressed(_ sender: Any) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let chatVC = storyboard.instantiateViewController(withIdentifier: "chatVCID") as! ChatVC
//        let myBoatBooks = storyboard.instantiateViewController(withIdentifier: "myboatBookVCID") as! MyBoatBookVC
//       
//        if let key = boatKey{
//            chatVC.boatkey = key
//            chatVC.receiverEmail = ClientTxt.text
//            chatVC.senderEmail = FIRAuth.auth()?.currentUser?.email
//         myBoatBooks.present(chatVC, animated: true, completion: nil)
//                }
//    }
    
}
