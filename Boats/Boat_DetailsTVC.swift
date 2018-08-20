//
//  Boat_DetailsTVC.swift
//  Boats
//
//  Created by Absolute Mac on 12/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
class Boat_DetailsTVC: UITableViewController {
    
    var booked : Bool = false
    var controller : ImagePageVC?
    var containerView: UIView?
   
    var selectedBoat : BoatLocal?
       let alertLoading  = AlertCustom().LoadingAlert()
    func addReviewforTest(){
        reviewsArray.append(Review(userEmail: "a", rating: 2, date: "", reviewContent: "aa", boatKey: (selectedBoat?.key)!))
        reviewsArray.append(Review(userEmail: "a", rating: 2, date: "", reviewContent: "aa", boatKey: (selectedBoat?.key)!))

        reviewsArray.append(Review(userEmail: "a", rating: 2, date: "", reviewContent: "aa", boatKey: (selectedBoat?.key)!))

    
    }
    
    //MARK: Arrays
    let sectionsTitlesArray = ["","Information","Description","Reviews",""]
    var reviewsArray : [Review] = []
    var imagesArray : [UIImage] = []
    //MARK : View funcs
    
    override func viewWillAppear(_ animated: Bool) {
        // present(alertLoading, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        configureTabPress()
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        
        registerCellsXibs()
        
        WebService().retrieveReviewFromFirebase(boatKey: (selectedBoat?.key)!) { (result) in
            
                if result.count > 0 {
                    self.reviewsArray = result
                    self.tableView.reloadData()
            }
            
        }

      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
            switch(section){
        case 0, 2 :
            return 1
        case 1:
            return 5
//        case 2:
//            return 1
        case 3:
            switch reviewsArray.count {
            case 0, 1:
                return 1
//            case 1:
//                return 1
            case 2 :
                return 2
            default :
                return 3
            }
            
        
        default:
            if !booked {
                return 1
            } else
            {
                return 0
                }
           
        }
    
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionsTitlesArray[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 3 && reviewsArray.count > 3
       {
           return createViewForHeader(title: sectionsTitlesArray[section], haveButton: true)
       }else {
             return createViewForHeader(title: sectionsTitlesArray[section], haveButton: false)
       }
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 30
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.section == 0 {
//            return 200
//        }
//        else {
//            return 100
//        }
//    }
    
    func createViewForHeader(title : String,haveButton : Bool) -> UIView{
        let headerVIew = UIView(frame: CGRect(x: 0, y: 0, width: 250, height: 50))
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        
        label.text = title
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        headerVIew.backgroundColor = UIColor.lightGray
       
        headerVIew.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: headerVIew.topAnchor, constant: 0),
            label.leadingAnchor.constraint(equalTo: headerVIew.leadingAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: headerVIew.bottomAnchor, constant: 0)
            
            ])
        
        if haveButton {
            
            let button  = UIButton(frame: CGRect(x: 250, y: 0, width: 50, height: 40))
            button.setTitle("More", for: .normal)
            button.addTarget(self, action: #selector(btnPress), for: .touchDown)
            headerVIew.addSubview(button)
            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.trailingAnchor.constraint(equalTo: headerVIew.trailingAnchor, constant: 8),
                button.topAnchor.constraint(equalTo: headerVIew.topAnchor, constant: 0),
                button.bottomAnchor.constraint(equalTo: headerVIew.bottomAnchor, constant: 0),
                button.widthAnchor.constraint(equalToConstant: 70)
                ])
        
        }
        
        
        
        return headerVIew
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch(indexPath.section){
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCelliD", for: indexPath) as! ImageCell
           
//                    WebService().retrieveArrayOfImages(boatKey: (self.selectedBoat?.key)!, completation: { (result) in
//                        cell.configureCell(images: result)
//                    })
            cell.configureCell(key: (selectedBoat?.key)!)
            
            
           
            return cell
        case 1:
          return getInfoCells(indexPath: indexPath)
        case 2:
             let cell = tableView.dequeueReusableCell(withIdentifier: "descCellid", for: indexPath) as! DescriptionCell
             cell.configureCell(description: (selectedBoat?.desc)!)
            return cell
        case 3:
            
               return  getReviewCells(indexPath: indexPath)
            
          
        default:
             let cell = tableView.dequeueReusableCell(withIdentifier: "chatbookCellid", for: indexPath) as! Chat_BooksCell
            cell.delegate = self as ChatBookDelegate
            return cell
        }
        
      //  return cell
       
    }
    func getReviewCells(indexPath : IndexPath) -> UITableViewCell {
        if reviewsArray.count > 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reviewCelliD", for: indexPath) as! ReviewCell
        cell.configureCell(review: reviewsArray[indexPath.row])
        return cell
        }else {
             let cell = tableView.dequeueReusableCell(withIdentifier: "noReviewCelliD", for: indexPath) as! noReviewCell
            return cell
        }
    }
    
    func getInfoCells(indexPath : IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "infoCelliD", for: indexPath) as! InfoCell
        
        switch indexPath.row {
        case 0:
            cell.configureCell(name: "Name", date: (selectedBoat?.model)!)
        case 1:
            cell.configureCell(name: "Owner", date: (selectedBoat?.owner)!)
        case 2:
            cell.configureCell(name: "Capacity", date: (selectedBoat?.capacity)!)
        case 3:
            cell.configureCell(name: "Price", date: (selectedBoat?.price)!)
        default:
            cell.configureCell(name: "Phone", date: (selectedBoat?.phoneNumber)!)
            
        }
        return cell
    }
   

    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "allReviewsSegue" {
            let dc = segue.destination as! AllReviewTVC
            dc.reviewsArray = reviewsArray
        }else if segue.identifier == "segueChat"{
            let dc = segue.destination as! ChatVC
            dc.boatkey = selectedBoat?.key
            dc.senderEmail = FIRAuth.auth()?.currentUser?.email
            dc.receiverEmail = selectedBoat?.owner
        
        } else if segue.identifier == "newBookSegue" {
            let dc = segue.destination as! newBookVC
            dc.selectedBoat = selectedBoat
        }else if segue.identifier == "PageVCSegue"{
            let dc = segue.destination as! ImagePageVC
            dc.boatkey = selectedBoat?.key
    }
    }

    //MARK: Register Xibs
    func registerCellsXibs(){
        tableView.register(UINib(nibName: "ImageCell", bundle: nil) , forCellReuseIdentifier: "ImageCelliD")
        
        tableView.register(UINib(nibName: "InfoCell", bundle: nil) , forCellReuseIdentifier: "infoCelliD")
        
        tableView.register(UINib(nibName: "DescriptionCell", bundle: nil) , forCellReuseIdentifier: "descCellid")
        
        tableView.register(UINib(nibName: "ReviewCell", bundle: nil) , forCellReuseIdentifier: "reviewCelliD")
        
        tableView.register(UINib(nibName: "MoreReviewCell", bundle: nil) , forCellReuseIdentifier: "moreReviewCellid")
        
        tableView.register(UINib(nibName: "Chat&BooksCell", bundle: nil) , forCellReuseIdentifier: "chatbookCellid")
        
        tableView.register(UINib(nibName: "noReviewCell", bundle: nil) , forCellReuseIdentifier: "noReviewCelliD")
        
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
            if indexPath.section == 0 {
                 performSegue(withIdentifier: "PageVCSegue", sender: self)
            }
           
            
        }
    }

    
    
    
}
extension Boat_DetailsTVC : MoreReviewButtonDelegate,ChatBookDelegate {
    //More btn
    func btnPress() {
        performSegue(withIdentifier: "allReviewsSegue", sender: self)
        
    }
    //
    func bookPress() {
        performSegue(withIdentifier: "newBookSegue", sender: self)
        
    }
    func chatPress() {
        performSegue(withIdentifier: "segueChat", sender: self)
    }
}
