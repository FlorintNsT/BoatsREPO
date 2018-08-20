//
//  MyBoat_ImagesVC.swift
//  Boats
//
//  Created by Absolute Mac on 25/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class MyBoat_ImagesVC: UIViewController, MyBoat_ImagesCellDelegate ,UICollectionViewDataSource, UICollectionViewDelegate    {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var multiEditButton: UIButton!
    var imagesURLSArray: [String] = []
    var imagesURLSArrayForDelete: [String] = []
    var selectedBoatKey: String?
    
    var actionType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.allowsMultipleSelection = false
        collectionView.allowsSelection = false
        collectionView.delegate = self
        collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "MyBoat_ImagesCell", bundle: nil), forCellWithReuseIdentifier: "myBoatImgCellID")

        
        let rightButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(editButtonPressed))
        self.navigationItem.rightBarButtonItem = rightButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate funcs
    func pushBack() {
        navigationController?.popViewController(animated: true)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myBoatImgCellID", for: indexPath) as! MyBoat_ImagesCell
        cell.configureCell(cellIndex: indexPath, imageUrl: imagesURLSArray[indexPath.row], sender: self, numberOfCell: imagesURLSArray.count)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesURLSArray.count
    }
    //MARK: Alert
    func showAlert(message mesaj : String){
        let alert = UIAlertController(title: mesaj, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: {
        (UIAlertAction) in
        self.navigationController?.popViewController(animated: true)
        }))
        self.present(alert, animated: true, completion: nil)
    }
//    
    override var isEditing: Bool{
        didSet{
            if self.isEditing{
//                navigationController?.navigationBar.barTintColor = UIColor.red
            } else{
                navigationController?.navigationBar.barTintColor = UIColor.blue
            }
        }
        
    }
    
    func showDeleteImagesAction(){


    actionType = "Delete"
        self.isEditing = true
        showEditing()
    }
    
    func changePreviewImageAction(){
       self.isEditing = true
        actionType = "ChangePreview"
        showEditing()
    }
    
    func showEditing()
    {
        
        if(self.isEditing == true)
        {
            self.isEditing = false
            self.navigationItem.rightBarButtonItem?.title = "Done"
            self.navigationController?.navigationBar.barTintColor = UIColor.red
            collectionView.allowsMultipleSelection = true
            collectionView.allowsSelection = true
        
            
        
        }
        else
        {
            self.isEditing = true
            navigationController?.navigationBar.barTintColor = UIColor.white

            self.navigationItem.rightBarButtonItem?.title = "Edit"
            collectionView.allowsMultipleSelection = false
            collectionView.allowsSelection = false
            if actionType == "Delete"{
            tryDeleteSelectedCells()
            }
            

        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    func tryDeleteSelectedCells(){
        
        if imagesURLSArrayForDelete.count == imagesURLSArray.count {
            showAlert(message: "Can't Delete all images")
        } else if imagesURLSArrayForDelete.count + 1 == imagesURLSArray.count {
            deleteSelectedCells()
            WebService().changePreviewImage(boatKey: selectedBoatKey!, imageURL: imagesURLSArray.first!)
        } else{
            deleteSelectedCells()
        }
    }
    
    func deleteSelectedCells(){
        
        for imageUrl in imagesURLSArrayForDelete{
            self.imagesURLSArray = self.imagesURLSArray.filter {$0 != imageUrl}
            WebService().deleteImage(imageURL: imageUrl, completation: { (result) in
                if result{

                
//                    self.imagesURLSArray = self.imagesURLSArray.filter {$0 != imageUrl}

                }
            })
            
        }
       
        collectionView.reloadData()
        imagesURLSArrayForDelete = []

    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! MyBoat_ImagesCell
        
        
        if actionType == "ChangePreview"{
            
            WebService().changePreviewImage(boatKey: selectedBoatKey!, imageURL: cell.URL!)

            
            showAlert(message: "Preview Image has been changed")

        
        } else {
            
            if let cellURL = cell.URL{
                imagesURLSArrayForDelete.append(cellURL)
                
            }
            
        }
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! MyBoat_ImagesCell
        
        if let cellURL = cell.URL{
           imagesURLSArrayForDelete =  imagesURLSArrayForDelete.filter{$0 != cellURL}
            
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func editButtonPressed(){
        if self.isEditing == true{
            showActionSheet()
        } else {
            showEditing()
        }
    }
    
    
    func showActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete images", style: .default) { (UIAlertAction) in
            
            self.showDeleteImagesAction()
        }
        
        let changesAction = UIAlertAction(title: "Change Preview Image", style: .default) { (UIAlertAction) in
          
            self.changePreviewImageAction()
                   }
        

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
            print("cancel")
        }
        
        alertController.addAction(deleteAction)
        alertController.addAction(changesAction)
//        alertController.addAction(reviewAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    

}
