//
//  Add_boatsVC.swift
//  Boats
//
//  Created by Absolute Mac on 13/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
class Add_boatsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    //MARK: Vars and Lets
    var ImageCollection : ImageCollectionVC?
   
    var textFieldRealYPosition: CGFloat = 0.0 // ptr pozitia textfield-ului la edit
    
    //MARK: Outlets
    
    @IBOutlet weak var imagePreviewView: UIImageView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var capacityTextField: UITextField!
    @IBOutlet weak var LocationTextField: UITextField!
    
    @IBOutlet weak var PhoneNumberTextField: UITextField!
    @IBOutlet weak var boatTypeSegmentedController: UISegmentedControl!
    
    @IBOutlet weak var selectImgBTN: UIButton!
    @IBOutlet weak var DescTextView: UITextView!
    
    private var imagePicker: UIImagePickerController?
    
    var keyBoardHeight: CGFloat?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        
        DescTextView.text = "Description"
        DescTextView.textColor = UIColor.lightGray
        DescTextView.delegate = self
        nameTextField.delegate = self
        priceTextField.delegate = self
        capacityTextField.delegate = self
        LocationTextField.delegate = self
         PhoneNumberTextField.delegate = self

        
        roundButton(button: selectImgBTN)
//        imagePicker.delegate = self
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
//        configureTapPress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    
    //MARK: Image Picker
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    @IBAction func selectImgBtn(_ sender: Any) {
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        imagePicker?.allowsEditing = false
        imagePicker?.sourceType = .photoLibrary
        
        if let imgPick = imagePicker{
            present(imgPick, animated: true, completion: nil)
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let img = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        if let compressedImage = self.resizeImage(image: img, targetSize: CGSize(width: 481, height: 551)) {
            DispatchQueue.main.async {
               
//                self.imagePreviewView.image = compressedImage
//                self.imagePreviewView.clipsToBounds = true
            
                self.ImageCollection?.imagesArray.append(compressedImage)
            }
        }
      
//        selectImgBTN.setTitle("", for: .normal)
        configureTapPress()
        dismiss(animated: true, completion: nil)
        imagePicker = nil
    }
    //MARK: Outlet Actions
    
    


    @IBAction func addBtn(_ sender: Any) {
       
        guard let imagesArray = ImageCollection?.imagesArray, (imagesArray.count != 0) else {
            AlertService().showAlert(mesaj: "Select One or more images", withCurentVC: self)
            return
        }

        
        guard let model = nameTextField!.text , !model.isEmpty else {
            AlertService().showAlert(mesaj: "Enter Boat Model", withCurentVC: self)
         
            return
        }
        
        guard let price = priceTextField!.text , !price.isEmpty else {
           AlertService().showAlert(mesaj: "Enter Boat Price Per Day", withCurentVC: self)
            return
        }
        
        guard let capacity = capacityTextField!.text , !capacity.isEmpty else {
             AlertService().showAlert(mesaj: "Enter Boat Capacity", withCurentVC: self)
            return
        }
        
        guard let location = LocationTextField!.text , !location.isEmpty else {
            AlertService().showAlert(mesaj: "Enter Boat Location", withCurentVC: self)
            
            return
        }
        
        guard let phoneNumber = PhoneNumberTextField!.text ,  !phoneNumber.isEmpty else {
             AlertService().showAlert(mesaj: "Enter Phone Number", withCurentVC: self)
           
            return
        }
        
        guard let description = DescTextView!.text , !description.isEmpty else {
           AlertService().showAlert(mesaj: "Enter Description", withCurentVC: self)
            
            return
        }
        
        
       
        WebService().addPost(model: model, price: price, capacity: capacity, images: imagesArray, location: location, type: boatTypeSegmentedController.titleForSegment(at: boatTypeSegmentedController.selectedSegmentIndex)!, desc: description, phoneNumber: phoneNumber)
        self.navigationController?.popViewController(animated: true)
    }
    
    func pressOnImagePreview(){
      
        
        let pageVC = self.storyboard?.instantiateViewController(withIdentifier: "imagesPageViewControllerID") as! ImagePageVC
         pageVC.imagesObjects = (ImageCollection?.imagesArray)!
        
        //        performSegue(withIdentifier: "segueAddImageVC", sender: self)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.pushViewController(pageVC, animated: true)
    
    }
    func configureTapPress(){
        let tapPressGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pressOnImagePreview))
        self.containerView.addGestureRecognizer(tapPressGestureRecognizer)
        
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segeImageCollection"{
            ImageCollection = segue.destination as? ImageCollectionVC
    } else if segue.identifier == "segueAddImageVC"{
            let dc = segue.destination as! ImagePageVC
            dc.imagesObjects = (ImageCollection?.imagesArray)!
    }
    }
}
extension Add_boatsVC{
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
//MARK: TextView Placeholder
extension Add_boatsVC : UITextViewDelegate , UITextFieldDelegate {
   
    @objc func keyboardWillShow(notification: NSNotification) {

        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
         keyBoardHeight = keyboardRectangle.height
 
    }
        
    
    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.4) {
            self.scrollView.contentInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
            self.scrollView.setContentOffset(CGPoint(x: 0,y: 0), animated: true)

        }
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {

        let textFieldLocation = CGPoint(x: textField.frame.midX, y: textField.frame.midY)
        let tfLocInScroll = contentView.convert(textFieldLocation, to: scrollView)
       
        if tfLocInScroll.y > 200 {

            scrollView.scrollToBottom(x: 0, keyboardHeight: textField.frame.height)
        
        }
        print(tfLocInScroll)
        
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {

        if let keyBoardH = keyBoardHeight {
             scrollView.scrollToBottom(x: 0, keyboardHeight: keyBoardH)
        }
        
       
        if textView.textColor == UIColor.lightGray {
            
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    

    func textViewDidEndEditing(_ textView: UITextView) {
                if textView.text.isEmpty {
            textView.text = "Description"
            textView.textColor = UIColor.lightGray
                } else {
//                    DescTextView.sizeToFit()

                }
    }
    
    //MARK: Design
    func roundButton(button : UIButton){
        //button.frame = CGRect(x: 160, y: 100, width: 50, height: 50)
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.clipsToBounds = true
    }

}

