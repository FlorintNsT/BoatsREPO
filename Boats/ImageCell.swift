//
//  ImageCell.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {

    @IBOutlet weak var SizeView: UIView!

    var boatKey : String?
    //MARK: Vars
    var controller : ImagePageVC?
    var containerView: UIView?
   
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addContainer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func addContainer(){
         let container = UIView()

        self.contentView.addSubview(container)
        
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            (container.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 0)),
            (container.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 0)),
            (container.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 0)),
            (container.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: 0)),
            (container.heightAnchor.constraint(equalToConstant: 200))
          
                        ])
         containerView = container

    }
    
    func addPageView(bKey: String){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let controllerPage =  storyboard.instantiateViewController(withIdentifier: "imagesPageViewControllerID") as! ImagePageVC
        controllerPage.boatkey = bKey
        if let container = containerView{
            
            controllerPage.view.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview(controllerPage.view)
            
            NSLayoutConstraint.activate([
                (controllerPage.view.leadingAnchor.constraint(equalTo: (container.leadingAnchor),constant: 0)),
                (controllerPage.view.trailingAnchor.constraint(equalTo: (container.trailingAnchor),constant: 0)),
                (controllerPage.view.topAnchor.constraint(equalTo: (container.topAnchor),constant: 0)),
                (controllerPage.view.bottomAnchor.constraint(equalTo: (container.bottomAnchor),constant: 0))
                ])
            
            controller = controllerPage
        }
        
      
    
    }
    func configureCell(key: String) {
        
      //  controller?.boatkey = key
        addPageView(bKey: key)
    
        
    
    }
}
