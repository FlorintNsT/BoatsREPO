//
//  BoatsVC.swift
//  Boats
//
//  Created by Absolute Mac on 12/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase


class BoatsVC: UIViewController  {
    //aici e o diff
    //MARK : Variables
    var refPosts: FIRDatabaseReference!
    var myBoatsArray : [BoatLocal] = []
    var filteredBoatsArray : [BoatLocal] = []
    var boatForSend : BoatLocal?
    var filter : Filter?{
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK : Outlets
    @IBOutlet weak var boatTypeSegmentedControlle: UISegmentedControl!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK : Load funcs
    override func viewDidLoad() {
        super.viewDidLoad()
       
        filter = nil
        hideKeyboardWhenTappedAround()

        searchBar.placeholder = "Enter boat model"
        searchBar.delegate = self
        collectionView.delegate = self as UICollectionViewDelegate
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
       
        configureTapPress()
        addRefreshController()
        
        WebService().retrivePostsFromFirebase(forCurrentUser: false, completation: {
            result in
            self.myBoatsArray = result
            self.collectionView.reloadData()
        })
   
        
    
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func myBoatsPressed(_ sender: Any) {
        performSegue(withIdentifier: "segueMy_boats", sender: self)
    }
    @IBAction func boatTypeChanged(_ sender: Any) {
        collectionView.reloadData()
    }
   
    @IBOutlet weak var bookBoatPressed: UIButton!


  }
extension BoatsVC :UICollectionViewDelegate,UICollectionViewDataSource{
    
    
        func addRefreshController(){
    
            
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .green
       
        var attributes = [String: AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.green
            
            
        refreshControl.attributedTitle = NSAttributedString.init(string: "Please wait", attributes: attributes)
        refreshControl.addTarget(self, action: #selector(refresh(refreshController:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
    }
    
    func refresh(refreshController: UIRefreshControl){
        collectionView.reloadData()
        refreshController.endRefreshing()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if searchBarIsEmpty(){
        
            return updateArrayFromFilter(array: getSelectedBoats(boatsArray: myBoatsArray)).count
           
        }else{
            return updateArrayFromFilter(array: getSelectedBoats(boatsArray: filteredBoatsArray)).count
       
        
        }
        
        
    }

    func getSelectedBoats(boatsArray :[BoatLocal]) -> [BoatLocal]{
        if boatTypeSegmentedControlle.titleForSegment(at: boatTypeSegmentedControlle.selectedSegmentIndex) == "All"{
            return boatsArray
        }else{
            return boatsArray.filter({ (boat) -> Bool in
                return boat.type.contains(boatTypeSegmentedControlle.titleForSegment(at: boatTypeSegmentedControlle.selectedSegmentIndex)!)
            })
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        var boat : BoatLocal
        
        if searchBarIsEmpty(){
          
              boat = updateArrayFromFilter(array: getSelectedBoats(boatsArray: myBoatsArray))[indexPath.row]
        }else{
           
             boat = updateArrayFromFilter(array: getSelectedBoats(boatsArray: filteredBoatsArray))[indexPath.row]
        }
       
        
        cell.configureCell(imgUrl: boat.image, pret: boat.price, model: boat.model, aval: boat.avability,location : boat.location , type : boat.type)
        
        return cell
    }
    
 //MARK: Gestures
    
    
    func configureTapPress(){
        let tapPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapPress(tapGesture: )))
        self.view.addGestureRecognizer(tapPressGestureRecognizer)
        self.collectionView.allowsSelection = true
    }
    
    func tapPress(tapGesture : UITapGestureRecognizer){
        
            let touchPoint = tapGesture.location(in: self.collectionView)
            if let indexPath = collectionView.indexPathForItem(at: touchPoint)
            {
                 boatForSend = myBoatsArray[indexPath.row]
                performSegue(withIdentifier: "segueDetails", sender: self)
                
            }
        
}

//MARK : Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetails"{
            let dest = segue.destination as! Boat_DetailsTVC
            dest.selectedBoat = boatForSend
            
        }else if segue.identifier == "segueFilter" {
            let dest = segue.destination as! FiltersVC
            dest.delegate = self
            dest.currentFilter = filter
        }
    
}

}
 //MARK : Filter
extension BoatsVC : UISearchBarDelegate {
    
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchBar.text?.isEmpty ?? true
       
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredBoatsArray = myBoatsArray.filter({( boat : BoatLocal) -> Bool in
            return boat.model.lowercased().contains(searchText.lowercased())
        })
        
        collectionView.reloadData()
    }
   
    
    
    func updateArrayFromFilter(array : [BoatLocal]) -> [BoatLocal]{
        var boatArray = array
        if filter == nil {
            return boatArray
        }else{
            if filter?.location != ""{
                boatArray = boatArray.filter({ (boat : BoatLocal) -> Bool in
                    return boat.location.lowercased() == filter?.location.lowercased()
                })
            }
            
            if filter?.MinPrice != "" {
                boatArray = boatArray.filter({ (boat : BoatLocal) -> Bool in
                    return boat.price > (filter?.MinPrice)!
                })
            }
            
            if filter?.MaxPrice != "" {
                boatArray = boatArray.filter({ (boat : BoatLocal) -> Bool in
                    return boat.price < (filter?.MaxPrice)!
                })
            }
       
        
            if filter?.minCapacity != "" {
                boatArray = boatArray.filter({ (boat : BoatLocal) -> Bool in
                    print("Bug aici")
                    return boat.capacity > (filter?.minCapacity)!
                })
            }
            
            if filter?.maxCapacity != "" {
                boatArray = boatArray.filter({ (boat : BoatLocal) -> Bool in
                    return boat.capacity < (filter?.maxCapacity)!
                })
            }
      
            if filter?.location == "" && filter?.MinPrice == "" && filter?.MaxPrice == "" && filter?.minCapacity == "" && filter?.maxCapacity == "" {
                filter = nil
            }
        }
        
        return boatArray
    }
}
extension BoatsVC : FiltersVCDelegate{
    func sendFilter(filterReceive: Filter) {
        filter = filterReceive
    }
}








