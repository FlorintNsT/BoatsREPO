//
//  Boat_DetailsVC.swift
//  Boats
//
//  Created by Absolute Mac on 18/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import Cosmos
protocol Boats_DetailDelegate {
    func giveMeTheBoat(boat : BoatLocal)
}

class Boat_DetailsVC: UIViewController , ReviewDelegate {
    
    var keyboardIsVisible : Bool = false
    var selectedBoat : BoatLocal?
    var txtInUse : Int?
     let datePicker = UIDatePicker()
    //MARK: Outlets
    @IBOutlet weak var txtStartDate: UITextField!
    @IBOutlet weak var boatImgView: UIImageView!
    
    @IBOutlet weak var capacityHereLabel: UILabel!
    @IBOutlet weak var ownerHereLabel: UILabel!
    @IBOutlet weak var priceHereLabel: UILabel!
    @IBOutlet weak var nameHereLabel: UILabel!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var bookMenuView: UIView!
    @IBOutlet weak var PhoneHereLabel: UILabel!
    @IBOutlet weak var txtEndDate: UITextField!
    
    @IBOutlet weak var descTextView: UITextView!
   
    @IBAction func txtSchima(_ sender: Any) {
     txtInUse = (sender as AnyObject).tag
    }
    
    @IBAction func txtSwitch(_ sender: Any) {
        
    }
   
    @IBAction func chatBtn(_ sender: Any) {
        performSegue(withIdentifier: "segueChat", sender: self)
    }
    @IBAction func showBookMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { 
            self.bookMenuView.isHidden = false
            self.blurView.isHidden = false
        }
        
    }
    @IBAction func exitBookMenu(_ sender: Any) {
        UIView.animate(withDuration: 0.3) {
            self.bookMenuView.isHidden = true
            self.blurView.isHidden = true
        }
    }
    
    //MARK: Add Review
    @IBOutlet weak var AddReviewVIew: UIView!
    
    @IBOutlet weak var textViewReviewContent: UITextView!
    @IBOutlet weak var CosmosStars: CosmosView!
    
    @IBAction func confirmReviewButtonPressed(_ sender: Any) {
        
        WebService().addReviewToFirebase(review: Review(userEmail: (FIRAuth.auth()?.currentUser?.email!)!, rating: CosmosStars.rating, date: "", reviewContent: textViewReviewContent.text, boatKey: (selectedBoat?.key)!))
        
            UIView.animate(withDuration: 0.3) {
            self.AddReviewVIew.isHidden = true
            self.blurView.isHidden = true
            
        }
            textViewReviewContent.text = ""
    }
    func addReview() {
        
        UIView.animate(withDuration: 0.3) {
            self.AddReviewVIew.isHidden = false
            self.blurView.isHidden = false
            
        }

    }
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
     //   configureTapPress()
        hideKeyboardWhenTappedAround()
        configureVC()
        showDatePicker(sender: txtStartDate)
        showDatePicker(sender: txtEndDate)
        descTextView.isUserInteractionEnabled = true
        addKeyBoardListener()
      
        bookMenuView.isHidden = true
        blurView.isHidden = true
        AddReviewVIew.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self) //remove observer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    //Mark: Configure View
    func configureVC(){
        nameHereLabel.text = selectedBoat?.model
        priceHereLabel.text = selectedBoat?.price
        ownerHereLabel.text = selectedBoat?.owner
        capacityHereLabel.text = selectedBoat?.capacity
        PhoneHereLabel.text = selectedBoat?.phoneNumber
        descTextView.text = selectedBoat?.desc
        setImage()
        

    }

    func setImage(){
        FIRStorage.storage().reference(forURL: (selectedBoat?.image)!).data(withMaxSize: 10*1024*1024) { (data, error) in
            DispatchQueue.main.async {
               // print(imgUrl)
                self.boatImgView.image = UIImage(data: data!)
               
            }
            
        }
    }
   
    //MARK: Press Outlet
    
    @IBAction func bookPress(_ sender: Any) {
       // WebService().addBook(boat: selectedBoat!, dateStart: (txtStartDate.text!), dateEnd: txtEndDate.text!, completation: //)
      
         //   self.bookMenuView.isHidden = true
         //   self.blurView.isHidden = true
        

        // navigationController?.popViewController(animated: true)
   
    }
    
    
    //MARK: Configure Date Picker
    func showDatePicker(sender : UITextField){
        
            //Formate Date
            datePicker.datePickerMode = .date
            
            //ToolBar
            let toolbar = UIToolbar();
            toolbar.sizeToFit()
            
            //done button & cancel button
            let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(donedatePicker) )
            let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
            toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
            
            // add toolbar to textField
            sender.inputAccessoryView = toolbar
            // add datepicker to textField
            sender.inputView = datePicker
        
}

   
    
    func donedatePicker(){
        //For date formate
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        if txtInUse == 1 {
            txtStartDate.text = formatter.string(from: datePicker.date)

        }else if txtInUse == 2{
            txtEndDate.text = formatter.string(from: datePicker.date)

        }
        
        //dismiss date picker dialog
        self.view.endEditing(true)
    }
    
    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }


    //MARK: Configure gestures
   

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else { return }
        if !bookMenuView.frame.contains(location) && AddReviewVIew.isHidden == true {
            UIView.animate(withDuration: 0.3) {
                self.bookMenuView.isHidden = true
                self.blurView.isHidden = true
                self.AddReviewVIew.isHidden = true
                
            }
        }else if !AddReviewVIew.frame.contains(location) && bookMenuView.isHidden == true && !keyboardIsVisible{
            UIView.animate(withDuration: 0.3) {
                self.bookMenuView.isHidden = true
                self.blurView.isHidden = true
                self.AddReviewVIew.isHidden = true
            }
        }
            
        if !textViewReviewContent.frame.contains(location){
            self.view.endEditing(true)
        }
        
    }

    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueChat"{
            let dc = segue.destination as! ChatVC
            dc.boatkey = selectedBoat?.key
            dc.senderEmail = FIRAuth.auth()?.currentUser?.email
            dc.receiverEmail = selectedBoat?.owner
        } else if segue.identifier == "reviewContainerSegue"{
            let dc = segue.destination as! ReviewVC
            dc.boatkey = selectedBoat?.key
            dc.delegate = self
        }
}

//MARK: Keyboard funcs
    func addKeyBoardListener() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil);
    }
    @objc func keyboardWillShow(_ notification: Notification) {
        keyboardIsVisible = true
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        keyboardIsVisible = false
    }
}
