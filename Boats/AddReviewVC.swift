//
//  AddReviewVC.swift
//  Boats
//
//  Created by Absolute Mac on 17/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import Cosmos
import FirebaseAuth
class AddReviewVC: UIViewController , UITableViewDelegate,UITableViewDataSource {
   //MARK: Oulets
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func addReviewBtnPressed(_ sender: Any) {
        
        UIView.animate(withDuration: 0.3) { 
            self.blurView.isHidden = false
            self.addReviewView.isHidden = false
        }
    }
    @IBOutlet weak var addReviewBtn: UIButton!
    //MARK: Vars and Lets
    var reviewsArray : [Review] = []
    var selectedBoat : BoatLocal?
    var keyboardIsVisible : Bool = false

    
    //MARK: VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        addKeyBoardListener()
        
        blurView.isHidden = true
        addReviewView.isHidden = true
        
        roundButton(button: addReviewBtn)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil) , forCellReuseIdentifier: "reviewCelliD")
        
        WebService().retrieveReviewFromFirebase(boatKey: (selectedBoat?.key)!) { (result) in
            // self.alertLoading.dismiss(animated: false, completion: nil)
            
            if result.count > 0 {self.reviewsArray = result
                self.tableView.reloadData()
            }
            
            
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self) //remove observer
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: tableView
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCelliD", for: indexPath) as! ReviewCell
        cell.configureCell(review: reviewsArray[indexPath.row])
        if cell.labelUserEmail.text == FIRAuth.auth()?.currentUser?.email{
            cell.labelUserEmail.text = "Me"
        }
        
        return cell
    }
   
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewsArray.count
    }
    
    // MARK: - AddReview
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var addReviewView: UIView!
    
    @IBAction func saveReviewBtn(_ sender: Any) {
        
        WebService().addReviewToFirebase(review: Review(userEmail: (FIRAuth.auth()?.currentUser?.email!)!, rating: ratingView.rating, date: "", reviewContent: textView.text, boatKey: (selectedBoat?.key)!))
        
        UIView.animate(withDuration: 0.3) {
            self.addReviewView.isHidden = true
            self.blurView.isHidden = true
            
        }
        textView.text = ""

        
    }
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var textView: UITextView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Configure gestures
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else {return}
        if !addReviewView.frame.contains(location) && !keyboardIsVisible {
            UIView.animate(withDuration: 0.3, animations: { 
                self.blurView.isHidden = true
                self.addReviewView.isHidden = true
            })
        }
        
        if !textView.frame.contains(location){
            self.view.endEditing(true)
        }
    }
    
    //MARK: Design
    func roundButton(button : UIButton){
        //button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
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

