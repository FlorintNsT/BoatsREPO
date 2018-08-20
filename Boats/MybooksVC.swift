//
//  MybooksVC.swift
//  Boats
//
//  Created by Absolute Mac on 20/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseAuth

class MybooksVC: UIViewController,bookCellDelegate {

    var myBooksArray : [BookLocal] = []
    var cellNum : Int?
    var selcBoat : BoatLocal? {
        didSet {
            
        }
    }
    @IBOutlet weak var aboutMeView: UIView!
    @IBOutlet weak var myEmailLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

           self.collectionView.register(UINib(nibName: "BooksCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "bookCell")
   
//        WebService().retrieveBooksFromFirebase(completation: {
//            result in
//            self.myBooksArray = result
//            self.collectionView.reloadData()
//        })
        aboutMeView.dropShadow()
        if let userEmail = FIRAuth.auth()?.currentUser?.email{
            myEmailLabel.text = userEmail
            
            myBooksArray = CoreDataService().getBooksFromCoreData(forUser: (userEmail))
            collectionView.reloadData()
            
        }
        
       
    }

    @IBAction func logOutButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
extension MybooksVC : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(myBooksArray.count)
        return myBooksArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bookCell", for: indexPath) as! BooksCellCollectionViewCell
        let Book = myBooksArray[indexPath.row]
        cell.configureCell(book: Book, cellNumber: indexPath.row)
        cell.delegate = self
        
        return cell
    }
    
    
    //MARK: Navigation
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "myBookToChatSegue"{
            let dc = segue.destination as! ChatVC
            dc.boatkey = myBooksArray[cellNum!].BookKey
            dc.senderEmail = FIRAuth.auth()?.currentUser?.email
            dc.receiverEmail = myBooksArray[cellNum!].boatOwner
        } else if segue.identifier == "bookToBoatDetailsSegue"{
           
             let dc = segue.destination as! Boat_DetailsTVC
             dc.booked = true 
            dc.selectedBoat = selcBoat
            }
          else if segue.identifier == "addReviewSegue"{
            let dc = segue.destination as! AddReviewVC
            dc.selectedBoat = selcBoat
        }
    }
   
    
    
        func chatPress(){
                   performSegue(withIdentifier: "myBookToChatSegue", sender: self)
        }
        
        func reviewPress(){
        WebService().retrivePost(boatKey: myBooksArray[cellNum!].BookKey, completation: { (result,isOkay) in
            if isOkay {
                self.selcBoat = result
                self.performSegue(withIdentifier: "addReviewSegue", sender: self)
            } else {
                AlertService().showAlert(mesaj: "Post is no longer exists", withCurentVC: self)
             
            }
 
        })

        }
    
        func detailsPress(){
            
            if let cellNumber = cellNum {
                
                WebService().retrivePost(boatKey: myBooksArray[cellNumber].BookKey, completation: { (result,isOkay) in
                    if isOkay {
                        self.selcBoat = result
                        self.performSegue(withIdentifier: "bookToBoatDetailsSegue", sender: self)
                    } else {
                        AlertService().showAlert(mesaj: "Post is no longer exists", withCurentVC: self)
                      
                    }
                    
                })
                
            }
        }
   
       func moreButtonPress(cellNumr: Int){
        cellNum = cellNumr
         showActionSheet()
      }
    
    func showActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chatAction = UIAlertAction(title: "Chat", style: .default) { (UIAlertAction) in
            self.chatPress()
        }
        
        let detailsAction = UIAlertAction(title: "Details", style: .default) { (UIAlertAction) in
            
            self.detailsPress()
        }
   
        let reviewAction = UIAlertAction(title: "Add Review", style: .default) { (UIAlertAction) in
            self.reviewPress()
            print("Show review")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        
        alertController.addAction(chatAction)
        alertController.addAction(detailsAction)
        alertController.addAction(reviewAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
   
       
   }



extension MybooksVC : WebServiceDelegate {
    func WebServiceFinish() {
         performSegue(withIdentifier: "bookToBoatDetailsSegue", sender: self)
    }


}
