//
//  ReviewVC.swift
//  Boats
//
//  Created by Absolute Mac on 11/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
protocol ReviewDelegate {
    func addReview()
}

class ReviewVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource  {

   //MARK: Outlets
    
    var reviewsArray : [Review] = []
    var boatkey : String?
    
    var delegate : ReviewDelegate?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func addButtonPressed(_ sender: Any) {
        delegate?.addReview()
        
    }
    @IBOutlet weak var addreviewBUtton: UIButton!
    //MARK: View funcs
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.register(UINib(nibName: "ReviewCollectionCell", bundle: nil), forCellWithReuseIdentifier: "reviewCell")
   
        WebService().retrieveReviewFromFirebase(boatKey: boatkey!) { (result) in
        self.reviewsArray = result
        self.collectionView.reloadData()
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return reviewsArray.count
        
    }
    
    //MARK: Collection funcs
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reviewCell", for: indexPath) as! ReviewCollectionCell
        let review = reviewsArray[indexPath.row]
        cell.configureCell(review: review)
        return cell
    }

 
}
