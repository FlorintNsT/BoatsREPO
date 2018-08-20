//
//  InboxVC.swift
//  Boats
//
//  Created by Absolute Mac on 09/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseAuth
class InboxVC: UIViewController , UITableViewDelegate, UITableViewDataSource{
   
    var myMessageArray : [Message] = []
    
    
    var selectedboatkey : String?
    var selectedsenderEmail : String?
    
    var receiverEmail : String?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
       receiverEmail = FIRAuth.auth()?.currentUser?.email
        configureTableView()
         tableView.register(UINib(nibName: "ChatCell", bundle: nil) , forCellReuseIdentifier: "chatCell")
            WebService().retrieveLastMessageFromFirebase(ReceiverEmail: receiverEmail!) { (result) in
                self.myMessageArray = result
                
                self.tableView.separatorStyle = .none
                self.tableView.reloadData()
        }
        configureTabPress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: Table view
    func configureTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120.0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell",for : indexPath) as! ChatCell
        cell.configureCell(message: myMessageArray[indexPath.row])
        cell.alignCell(direction: "center")
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         print(myMessageArray.count)
        return myMessageArray.count
    }
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueInboxChat"{
            let dest = segue.destination as! ChatVC
            dest.boatkey = selectedboatkey
            dest.receiverEmail = selectedsenderEmail
            //print(selectedsenderEmail!)
           // print(receiverEmail!)
            dest.senderEmail = receiverEmail
            
        }
    }


//MARK: Gestures 
    func configureTabPress(){
        let tapPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapPress(tapGesture: )))
        self.view.addGestureRecognizer(tapPressGestureRecognizer)
        self.tableView.allowsSelection = true
    }
    
    func tapPress(tapGesture : UITapGestureRecognizer){
        let touchPoint = tapGesture.location(in: self.tableView)
        if let indexPath = tableView.indexPathForRow(at: touchPoint)
        {
            selectedsenderEmail = myMessageArray[indexPath.row].SenderEmail
            selectedboatkey = myMessageArray[indexPath.row].selectedBoatKey
            performSegue(withIdentifier: "segueInboxChat", sender: self)
         
        }
    }
}
