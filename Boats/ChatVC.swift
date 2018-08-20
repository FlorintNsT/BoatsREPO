//
//  ChatVC.swift
//  Boats
//
//  Created by Absolute Mac on 29/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class ChatVC: UIViewController , UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    //MARK: Variables
    var myMessageArray : [Message] = []
    var receiverEmail : String?
    var boatkey : String?
    var senderEmail : String?
    var keyBoardHeight: CGFloat?
    var tabBarHeight: CGFloat?

    //MARK: Outlets
    @IBOutlet weak var textViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        textField.endEditing(true)
       
        
        guard let sender = senderEmail ,!sender.isEmpty else{
            
            return
        }
        
        WebService().addMessageToFirebase(message: Message(sendDate: " ", contentOfMessage: textField.text!, selectedBoatKey: boatkey!, SenderEmail: senderEmail!, RecevierEmail: receiverEmail!))
        textField.text = ""
        

    }
    
    
    
    //MARK: VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = .none
            getTabBarHeight()
            getKeyboardHeight()
            hideKeyboardWhenTappedAround()
            configureTableView()
            textField.delegate = self
            tableView.register(UINib(nibName: "ChatCell", bundle: nil) , forCellReuseIdentifier: "chatCell")
            tableView.delegate = self
            tableView.dataSource = self
            WebService().retrieveMessageFromFirebase(SenderEmail: senderEmail!, ReceiverEmail: receiverEmail!, selectedBoatKey: boatkey!) { (result) in
                self.myMessageArray = result
               
                    self.tableView.reloadData()
                    self.scrollBottom()
        }
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
    func getKeyboardHeight(){
        
        keyBoardHeight = KeyboardService.keyboardHeight()
        
    }
    func getTabBarHeight(){
        tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
    }
    
    
    //MARK: Table view
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell",for : indexPath) as! ChatCell
        if myMessageArray.count > 0 {
        cell.configureCell(message: myMessageArray[indexPath.row])
        }else {
            cell.configureCell(message: Message(sendDate: " ", contentOfMessage: "Start a new conversation", selectedBoatKey: "", SenderEmail: "", RecevierEmail: ""))
        }
             
        return cell
    
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // print(myMessageArray.count)
        if myMessageArray.count > 0 {
        return myMessageArray.count
        }else {
            return 1
        }
        
    }

    func scrollBottom() {
        let bottomOffset = CGPoint(x: 0, y: self.tableView.contentSize.height - self.tableView.frame.size.height)
        self.tableView.setContentOffset(bottomOffset, animated: false)
    }
    
    //MARK : Text field func 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
           
            if let keyBoardH = self.keyBoardHeight{
               
                    self.textViewHeight.constant = keyBoardH

               
            }
        
            
                self.view.layoutIfNeeded()
        }

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.2) {
            self.textViewHeight.constant = 48
            self.view.layoutIfNeeded()
           
        }
    }


    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func makeMeDelegate(){
        textField.delegate = self
       
    }
    
}
