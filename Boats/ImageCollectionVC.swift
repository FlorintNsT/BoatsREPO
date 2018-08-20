//
//  ImageCollectionVC.swift
//  Boats
//
//  Created by Absolute Mac on 19/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class ImageCollectionVC: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    //MARK : Outlets
    @IBOutlet weak var collectionView: UICollectionView!
   
    //MARK: Lets and Vars
    var imagesArray : [UIImage] = []{
        didSet{
            collectionView.reloadData()
        }
    }
    //MARK : VC funcs
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(UINib(nibName: "ImageCollectionCell", bundle: nil), forCellWithReuseIdentifier: "ImageCollectionCellID")

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: Collection funcs
    
    func addImage(img: UIImage){
        imagesArray.append(img)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionCellID", for: indexPath) as! ImageCollectionCell
        cell.configureCell(image: imagesArray[indexPath.row])
        return cell

    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
