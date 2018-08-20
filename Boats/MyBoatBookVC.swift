//
//  MyBoatBookVC.swift
//  Boats
//
//  Created by Absolute Mac on 20/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class MyBoatBookVC: UIViewController {

     var selectedBoat : BoatLocal?
    var myBooksArray : [BookLocal] = []

    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.collectionView.register(UINib(nibName: "MyBoatBookCell", bundle: nil), forCellWithReuseIdentifier: "MyBoatBookCell")
        
        if let boat = selectedBoat{
            
            WebService().retrieveMyBooksFromFirebase(MyBoat: boat, completation: {
                result in
                self.myBooksArray = result
                self.collectionView.reloadData()
            })
            
        }
       

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    

    

}

extension MyBoatBookVC : UICollectionViewDataSource,UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(myBooksArray.count)
        return myBooksArray.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyBoatBookCell", for: indexPath) as! MyBoatBookCell
        let Book = myBooksArray[indexPath.row]
        cell.configureCell(book: Book)
        
        return cell
    }
    
}
