//
//  ChatCell.swift
//  Boats
//
//  Created by Absolute Mac on 02/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
class ChatCell: UITableViewCell {

    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageTextLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
  
    
    //MARK: Constraints Outlets
    @IBOutlet weak var dateLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var dateLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var messageLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var messageLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var senderLabelLeading: NSLayoutConstraint!
    @IBOutlet weak var senderLabelTrailing: NSLayoutConstraint!
    @IBOutlet weak var backgroundLeading: NSLayoutConstraint!
    @IBOutlet weak var backgroundTrail: NSLayoutConstraint!
    
    @IBOutlet weak var colorView: UIView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(message : Message){
        
        messageTextLabel.text = message.contentOfMessage
        print(message.sendDate)
        if message.sendDate != " " {
            
            if message.sendDate.substring(to:message.sendDate.index(message.sendDate.startIndex, offsetBy: 10)) == WebService().getToday(withHour: false) {
                
                dateLabel.text = "Today, ".appending(String(message.sendDate.characters.suffix(5)))
                
            }else{
                
                dateLabel.text = message.sendDate
                
            }
            
        }else{
            dateLabel.text = message.sendDate

        }
        
        
        colorView.layer.cornerRadius = 8.0
        colorView.clipsToBounds =  true
        
        if message.SenderEmail == FIRAuth.auth()?.currentUser?.email!{
            senderLabel.text = "Me"
            colorView.backgroundColor = UIColor.yellow
            
            alignCell(direction: "right")
        }else {
             colorView.backgroundColor = UIColor.cyan
            senderLabel.text = message.SenderEmail
            alignCell(direction: "left")
        }
    
    }
    
    func alignCell(direction : String){
        if direction == "left"{
            
            backgroundTrail.constant = 80
            senderLabelTrailing.constant = 80
            messageLabelTrailing.constant = 80
            dateLabelTrailing.constant = 80
        
            backgroundLeading.constant = 8
            senderLabelLeading.constant = 8
            messageLabelLeading.constant = 8
            dateLabelLeading.constant = 8
            
            
        } else if direction == "right" {
            backgroundLeading.constant = 80
            senderLabelLeading.constant = 80
            messageLabelLeading.constant = 80
            dateLabelLeading.constant = 80
            
            backgroundTrail.constant = 8
            senderLabelTrailing.constant = 8
            messageLabelTrailing.constant = 8
            dateLabelTrailing.constant = 8
       
        } else if direction == "center" {
            backgroundLeading.constant = 8
            senderLabelLeading.constant = 8
            messageLabelLeading.constant = 8
            dateLabelLeading.constant = 8
          
            backgroundTrail.constant = 8
            senderLabelTrailing.constant = 8
            messageLabelTrailing.constant = 8
            dateLabelTrailing.constant = 8

        }




}


}





