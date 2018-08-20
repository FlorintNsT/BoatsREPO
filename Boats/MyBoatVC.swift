//
//  MyBoatVC.swift
//  Boats
//
//  Created by Absolute Mac on 18/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import FirebaseStorage
class MyBoatVC: UIViewController {
    
    //MARK: Vars And Lets
    var selectedBoat : BoatLocal?
    var imagePicker: UIImagePickerController?
    var imagesPages: ImagePageVC?
    var keyBoardHeight: CGFloat?
    
    
   //MAR: Outlets
    @IBOutlet weak var imagesContainerView: UIView!
    
    @IBOutlet weak var viewUpdateControls: UIView!
    @IBOutlet weak var capacityTxt: UITextField!
    @IBOutlet weak var priceTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
   
    @IBOutlet weak var booksAndchatStackView: UIStackView!
    @IBOutlet weak var descTextView: UITextView!
    @IBOutlet weak var phoneNumbetTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
   
    //MARK: View funcs
    override func viewDidLoad() {
        super.viewDidLoad()
       // changeInteractionControl(isEnable: false)
        configureBoat()
        hideKeyboardWhenTappedAround()
//        switchBtnTitle()
//        hideView()
        setKeyboardHeight()
        configTextFieldsDelegate()
        addBooksNavButton()
        
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
   
    func changeInteractionControl(isEnable choice: Bool){
        nameTxt.isUserInteractionEnabled = choice
        priceTxt.isUserInteractionEnabled = choice
        capacityTxt.isUserInteractionEnabled = choice
        locationTxt.isUserInteractionEnabled = choice
        phoneNumbetTxt.isUserInteractionEnabled = choice
        descTextView.isUserInteractionEnabled = choice
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
    }
    
    //MARK: Buttons
   
    @IBAction func editPressed(_ sender: Any) {
        showActionSheet()
    }
    
    func addBooksNavButton(){
        let rightButton = UIBarButtonItem(title: "Books", style: UIBarButtonItemStyle.plain, target: self, action: #selector(showBooksForMyBoat))
        self.navigationItem.rightBarButtonItem = rightButton
        
        changeInteractionControl(isEnable: false)
    }
    
    func showBooksForMyBoat(){
        performSegue(withIdentifier: "segueMyBoatBooks", sender: self)

    }
    
    
    func configTextFieldsDelegate(){
        phoneNumbetTxt.delegate = self as UITextFieldDelegate
        capacityTxt.delegate = self as UITextFieldDelegate
        priceTxt.delegate = self as UITextFieldDelegate
        nameTxt.delegate = self as UITextFieldDelegate
        descTextView.delegate = self as UITextViewDelegate
    }
    
    //MARK: Configure boat
    func configureBoat(){
        nameTxt.text = selectedBoat?.model
        priceTxt.text = selectedBoat?.price
        capacityTxt.text = selectedBoat?.capacity
        locationTxt.text = selectedBoat?.location
        phoneNumbetTxt.text = selectedBoat?.phoneNumber
        descTextView.text = selectedBoat?.desc
       // setImage()
       
        
    }

    func addFinishEditButton(){
        self.navigationController?.navigationBar.barTintColor = UIColor.red
        
               let rightButton = UIBarButtonItem(title: "Finish", style: UIBarButtonItemStyle.plain, target: self, action: #selector(finishEditInfo))
        self.navigationItem.rightBarButtonItem = rightButton
   
    }
    func finishEditInfo(){
        
        if let boatKey = selectedBoat?.key{
            

            WebService().deleteObjectFromFirebase(child: "Posts", childKey: "Key", keyForDelete: boatKey){
                self.createNewBoatFromView(completation: { (boat) in
                    WebService().addPostUpdated(boat: boat)
                })
                
                
            }
            
        }
        
        
        
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        addBooksNavButton()
    }
    
    func createNewBoatFromView(completation: (BoatLocal) -> ()) {
        
       
        
        guard let newBoatModel  = nameTxt.text , !newBoatModel.isEmpty else{
            AlertService().showAlert(mesaj: "Boat Model is missing", withCurentVC: self)

           
            return
        }
        guard let newPrice = priceTxt.text , !newPrice.isEmpty else{
            AlertService().showAlert(mesaj: "Price is missing", withCurentVC: self)

                return
        }
        guard  let newCapacity = capacityTxt.text, !newCapacity.isEmpty else{
            AlertService().showAlert(mesaj: "Capacity is missing", withCurentVC: self)

          
            return
        }
        guard let newLocation = locationTxt.text , !newLocation.isEmpty else {
            AlertService().showAlert(mesaj: "Location is missing", withCurentVC: self)

                return
        }
        
        guard let newPhoneNumber = phoneNumbetTxt.text , !newPhoneNumber.isEmpty else {
            AlertService().showAlert(mesaj: "Phone Number is missing", withCurentVC: self)

           
            return
        }
        guard let newDesc = descTextView.text , !newDesc.isEmpty else {
            AlertService().showAlert(mesaj: "Description is missing", withCurentVC: self)

            
            return
        }
        
        guard let imageURL = selectedBoat?.image , !imageURL.isEmpty else{
            AlertService().showAlert(mesaj: "Image is missing", withCurentVC: self)

                return
            
        }
        
        guard let owner = selectedBoat?.owner , !owner.isEmpty else{
            return
        }
        guard  let boatKey = selectedBoat?.key , !boatKey.isEmpty else {
            return
        }
        guard let avability = selectedBoat?.avability , !avability.isEmpty else {
            return
        }
        guard let type = selectedBoat?.type , !type.isEmpty else {
            return
        }
        
       
        
        
        let newBoat = BoatLocal(image: imageURL, price: newPrice, owner: owner, capacity: newCapacity, model: newBoatModel, key: boatKey, avability: avability, type: type, location: newLocation, desc: newDesc, phoneNumber: newPhoneNumber)
        
        completation(newBoat)
    }
    //MARK: Action Sheet
    func showActionSheet(){
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let chatAction = UIAlertAction(title: "Add Image", style: .default) { (UIAlertAction) in
            self.showImagePicker()
        }
        
        let detailsAction = UIAlertAction(title: "Edit Images", style: .default) { (UIAlertAction) in
            
            self.performSegue(withIdentifier: "segueImagesCollection", sender: self)
        }
        
        let reviewAction = UIAlertAction(title: "Edit Information", style: .default) { (UIAlertAction) in
            self.changeInteractionControl(isEnable: true)
            self.addFinishEditButton()
        }
       
        let deleteAction = UIAlertAction(title: "Delete Post", style: .destructive) { (UIAlertAction) in
            WebService().deletePost(boatKey: (self.selectedBoat?.key)!)
            self.navigationController?.popViewController(animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (UIAlertAction) in
//            print("cancel")
        }
        
        alertController.addAction(chatAction)
        alertController.addAction(detailsAction)
        alertController.addAction(reviewAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMyBoatBooks"{
            let dc = segue.destination as! MyBoatBookVC
            dc.selectedBoat = selectedBoat
        } else if segue.identifier == "segueImagePages"{
            imagesPages  = segue.destination as? ImagePageVC
            imagesPages?.boatkey = selectedBoat?.key
        }else if segue.identifier == "segueImagesCollection"{
            let dc = segue.destination as! MyBoat_ImagesVC
            if let imgArray = imagesPages?.imagesURLS{
                dc.imagesURLSArray = imgArray
                dc.selectedBoatKey = selectedBoat?.key
                
            }
           
        }

}

    func showAlert(mesaj : String){
        let alert = UIAlertController(title: mesaj, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

extension MyBoatVC : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func showImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = false
        imagePicker?.sourceType = .photoLibrary
        
        present(imagePicker!, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let compressedImage = self.resizeImage(image: img, targetSize: CGSize(width: 481, height: 551)) {
            DispatchQueue.main.async {
                
                var imgArray : [UIImage] = []
                imgArray.append(compressedImage)
                WebService().addArrayofImages(images: imgArray, key: (self.selectedBoat?.key)!)
                self.imagesPages?.viewDidLoad()
                
                
//                self.ImageCollection?.imagesArray.append(compressedImage)
            }
        }
        
//        selectImgBTN.setTitle("", for: .normal)
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        let size = image?.size
        
        let widthRatio  = targetSize.width  / (size?.width)!
        let heightRatio = targetSize.height / (size?.height)!
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: (size?.width)! * heightRatio, height: (size?.height)! * heightRatio)
        } else {
            newSize = CGSize(width: (size?.width)! * widthRatio,  height: (size?.height)! * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image?.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}

//MARK: Keyboard Funcs
extension MyBoatVC : UITextFieldDelegate , UITextViewDelegate {
    
    func setKeyboardHeight(){

        keyBoardHeight = KeyboardService.keyboardHeight()
        
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let keyHeight = keyBoardHeight{
            //           thetextField.convert(thetextField.frame.origin, to:self.view)
            let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
            let textBox = textField.convert(textField.frame.origin, to: self.view)
            if textBox.y > keyHeight {
                
                
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame.origin.y -=  tabBarHeight + textBox.y - (self.view.frame.height - keyHeight)
                })
                
                
            }
            
        }
        
        return true
    }
    
    

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.frame.origin.y = 0
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
      
        if let keyHeight = keyBoardHeight{
            let tabBarHeight = self.tabBarController?.tabBar.frame.height ?? 49.0
            let textBox = textView.frame.origin
            if textBox.y > keyHeight {
              
                UIView.animate(withDuration: 0.3, animations: { 
                    self.view.frame.origin.y -= textView.frame.height + tabBarHeight + textBox.y - (self.view.frame.height - keyHeight)
                })
                
                
                
            }
            
        }
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.frame.origin.y = 0
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        keyBoardHeight = keyboardRectangle.height
        
        
    }
    
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
           
        }
    }
}
