//
//  MyBoatsVC.swift
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

class MyBoatsVC: UIViewController {
    
    var refPosts: FIRDatabaseReference!
    var myBoatsArray : [BoatLocal] = []
    var boatForSend : BoatLocal?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var inboxBtn: UIButton!
    
    @IBOutlet weak var addBTN: UIButton!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        roundButton(button: addBTN)
        roundButton(button: inboxBtn)
        
        collectionView.delegate = self as UICollectionViewDelegate
        self.collectionView.register(UINib(nibName: "CollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        WebService().retrivePostsFromFirebase(forCurrentUser: true, completation: {
            result in
            self.myBoatsArray = result
            self.collectionView.reloadData()
        })
    
        configureTapPress()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addBoat(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "Add_boatsVC") {
            navigationController?.pushViewController(vc, animated: true)
        }
    }

    
}
extension MyBoatsVC :UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("aici se tipa")
        return myBoatsArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell
        let boat = myBoatsArray[indexPath.row]
        cell.configureCell(imgUrl: boat.image, pret: boat.price, model: boat.model, aval: boat.avability, location: boat.location, type: boat.type)
        
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
            performSegue(withIdentifier: "segueMy_book", sender: self)
          //  WebService().deletePost(object: boatForSend!)
        }
        
    }
    
    //MARK : Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMy_book"{
            let dest = segue.destination as! MyBoatVC
            dest.selectedBoat = boatForSend
        } 
    }
    
    //MARK: Design
    func roundButton(button : UIButton){
        //button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }
}
