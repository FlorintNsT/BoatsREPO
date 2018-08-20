//
//  WebService.swift
//  Boats
//
//  Created by Absolute Mac on 14/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

protocol WebServiceDelegate {
    func WebServiceFinish()
}

class WebService {
     var refPosts: FIRDatabaseReference!
    
    var delegate : WebServiceDelegate?
    
    //MARK: retrievePosts
    
   
    
    func retrivePost(boatKey : String , completation : @escaping (BoatLocal,Bool) -> ()) {
       refPosts = FIRDatabase.database().reference().child("Bd").child("Posts")
       
          let query = refPosts.queryOrdered(byChild: "Key").queryEqual(toValue: boatKey)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
           
            print("asa asa asa asa asa asa asa asa asa ")
            print(snapshot.childrenCount)
            
            if snapshot.childrenCount == 0 {
              
                 let boat = BoatLocal(image: "" , price: "", owner: "", capacity: "", model: "", key: "", avability: "", type: "", location: "", desc: "", phoneNumber: "" )
                
                 completation(boat,false)
            }
            
             for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
            let boatsObjects = boats.value as? [String: AnyObject]
           
            let boatModel  = boatsObjects?["Model"]
            let boatPrice  = boatsObjects?["Price"]
            let boatCapacity = boatsObjects?["Capacity"]
            let boatOwner = boatsObjects?["Owner"]
            let boatImage = boatsObjects?["myImageURL"]
            let boatKeyy   = boatsObjects?["Key"]
            let boatAval  = boatsObjects?["Available"]
            let boaLocation = boatsObjects?["Location"]
            let boatType = boatsObjects?["Type"]
            let boatDesc = boatsObjects?["Desc"]
            let boatPhoneNumber = boatsObjects?["phoneNumber"]
            print("asa asa asa asa asa asa asa asa asa ")
            print(boatKeyy as! String)
           
            let boat = BoatLocal(image: boatImage as! String, price: boatPrice as! String, owner: boatOwner as! String, capacity: boatCapacity as! String, model: boatModel as! String, key: boatKeyy as! String, avability: boatAval as! String, type: boatType as! String, location: boaLocation as! String, desc: boatDesc as! String, phoneNumber: boatPhoneNumber as! String)
        //    self.delegate?.WebServiceFinish()
            completation(boat, true)
            }
        })
    }
    
    func retrivePostsFromFirebase(forCurrentUser : Bool,completation: @escaping ([BoatLocal]) -> () ){
    
        refPosts = FIRDatabase.database().reference().child("Bd").child("Posts")
        
        let query = refPosts.queryOrdered(byChild: "Owner").queryEqual(toValue: FIRAuth.auth()?.currentUser?.email)
        let queryAval = refPosts.queryOrdered(byChild: "Available").queryEqual(toValue: "Yes")
        //let queryNot = refPosts.queryOrdered(byChild: "").que
        if forCurrentUser {
            query.observe(FIRDataEventType.value, with: { (snapshot) in
                
                completation(self.extractFromFirebasePosts(snapshot: snapshot))
            })
        }else{
            queryAval.observe(FIRDataEventType.value, with: { (snapshot) in
                
                if let userEmail = FIRAuth.auth()?.currentUser?.email{
                    
                    completation(self.extractFromFirebasePostsForClients(snapshot: snapshot, user: userEmail))
                    
                }
                
                
            })
        }
       
       
    }
    
    
    
    func deleteImage(imageURL: String,completation: @escaping (Bool) -> ()){
      let  refImages = FIRDatabase.database().reference().child("Bd").child("Images")
       let query = refImages.queryOrdered(byChild: "ImageURL").queryEqual(toValue: imageURL)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            for images in snapshot.children {
//           let imagesObjects = images.value as? [String: AnyObject]
                let userSnap = images as! FIRDataSnapshot
                let uid = userSnap.key //the uid of each user
              
                //let childID = uid
                self.deleteImageFromFireBase(key: uid, imageURL: imageURL)
                completation(true)
            }
            
        })

    }
//    func deletePostForUpdate(boatKey: String, completation: () -> ()){
//        deleteObjectFromFirebase(child: "Posts", childKey: "Key", keyForDelete: boatKey)
//        completation()
//    }
    func deletePost(boatKey: String){
        
        retrieveArrayOfImages(boatKey: boatKey) { (imgURLS) in
            for imgURL in imgURLS {
                self.deleteImage(imageURL: imgURL, completation: { (result) in
                    print("Deleted The Post")
                })
            }
        }
        
        
        
//        let refPosts = FIRDatabase.database().reference().child("Bd").child("Posts")
//        let query = refPosts.queryOrdered(byChild: "Key").queryEqual(toValue: boatKey)
//        
//        query.observeSingleEvent(of: .value, with: { (snapshot) in
//            for post in snapshot.children{
//                let userSnap = post as! FIRDataSnapshot
//                let uid = userSnap.key
//                
//                let refPost = FIRDatabase.database().reference().child("Bd").child("Posts").child(uid)
//                refPost.removeValue()
//                
//            }
//        })
        
        deleteObjectFromFirebase(child: "Posts", childKey: "Key", keyForDelete: boatKey){
            self.deleteObjectFromFirebase(child: "Review", childKey: "BoatKey", keyForDelete: boatKey){
                
            }
        }
       
    }
    func deleteObjectFromFirebase(child: String ,childKey: String ,keyForDelete: String,completation: @escaping () -> ()){
        
        let refPosts = FIRDatabase.database().reference().child("Bd").child(child)
        let query = refPosts.queryOrdered(byChild: childKey).queryEqual(toValue:keyForDelete)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            for post in snapshot.children{
                let userSnap = post as! FIRDataSnapshot
                let uid = userSnap.key
                
                let refPost = FIRDatabase.database().reference().child("Bd").child(child).child(uid)
                refPost.removeValue()
                completation()
            }
        })
        
    }
    
    func deleteImageFromFireBase(key: String,imageURL: String){
        let  refImages = FIRDatabase.database().reference().child("Bd").child("Images").child(key)
        
        refImages.removeValue()
        deleteImageFromStorage(url: imageURL)
        
    }
    func deleteImageFromStorage(url: String){
        FIRStorage.storage().reference(forURL: url).delete { (error) in
           
            if let err = error {
                print(err)

            }
            
            }
    }
    
    func iSImageUrlInFirebase(imageURL: String,completation: @escaping (Bool) -> ()){
        let  refImages = FIRDatabase.database().reference().child("Bd").child("Images")
        let query = refImages.queryOrdered(byChild: "ImageURL").queryEqual(toValue: imageURL)
        
        query.observeSingleEvent(of: .value, with: { (snapshot) in
            
            var rez : Bool
            if snapshot.childrenCount == 0 {
                rez = false
            } else {
                rez = true
            }
            completation(rez)
        })
        
        
    }
    
    func downImage(imgUrl: String,completation: @escaping (UIImage) -> ()){
        var Image : UIImage
       
        if let res =  CoreDataService().tryGetImageFromDisk(imageURL: imgUrl){
            Image = res
            completation(Image)
        } else {
            
            FIRStorage.storage().reference(forURL: imgUrl).data(withMaxSize: 10*1024*1024) { (data, error) in
                DispatchQueue.main.async {
                   
                    if let dataForImage = data {
                        CoreDataService().addImageObjectToCoreData(imageURL: imgUrl, img: UIImage(data: dataForImage)!)
                        completation(UIImage(data: data!)!)
                        

                    }
                    
                    }
                
            }
            
        }
        
        
        
    }
    
    func downloadImages(imagesURLS: [String] , completation: ([UIImage]) -> ()){
        
        var images : [UIImage] = []
        
        for imageURL in imagesURLS {
            
            downImage(imgUrl: imageURL, completation: { (img) in
                
                images.append(img)
                print("_________________ zdazdazda __________")
                })
            

        }
        print("_________________ ASA __________")
        print(images.count)
        completation(images)
       

            }
    
    
    func extractFromFirebasePostsForClients(snapshot : FIRDataSnapshot,user: String) -> [BoatLocal]{
        var myBoatsArray : [BoatLocal] = []
        if snapshot.childrenCount > 0 {
            
            
            //iterating through all the values
            for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
                //getting values
                let boatsObjects = boats.value as? [String: AnyObject]
                let boatModel  = boatsObjects?["Model"]
                let boatPrice  = boatsObjects?["Price"]
                let boatCapacity = boatsObjects?["Capacity"]
                let boatOwner = boatsObjects?["Owner"]
                let boatImage = boatsObjects?["myImageURL"]
                let boatKey   = boatsObjects?["Key"]
                let boatAval  = boatsObjects?["Available"]
                let boaLocation = boatsObjects?["Location"]
                let boatType = boatsObjects?["Type"]
                let boatDesc = boatsObjects?["Desc"]
                let boatPhoneNumber = boatsObjects?["phoneNumber"]
                
                if let userEmail = boatOwner  {
                    
                    if userEmail as! String != user{
                       
                        //creating boat object with model and fetched values
                        let boat = BoatLocal(image: boatImage as! String, price: boatPrice as! String, owner: boatOwner as! String, capacity: boatCapacity as! String, model: boatModel as! String, key: boatKey as! String, avability: boatAval as! String, type: boatType as! String, location: boaLocation as! String, desc: boatDesc as! String, phoneNumber: boatPhoneNumber as! String)
                        
                        //appending it to list
                        myBoatsArray.append(boat)
                        
                    }
                    
                }
                
               
            }
            
            
        }
        return myBoatsArray
    }
    
    
    func extractFromFirebasePosts(snapshot : FIRDataSnapshot) -> [BoatLocal]{
        var myBoatsArray : [BoatLocal] = []
        if snapshot.childrenCount > 0 {
            
            
            //iterating through all the values
            for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
                //getting values
                let boatsObjects = boats.value as? [String: AnyObject]
                let boatModel  = boatsObjects?["Model"]
                let boatPrice  = boatsObjects?["Price"]
                let boatCapacity = boatsObjects?["Capacity"]
                let boatOwner = boatsObjects?["Owner"]
                let boatImage = boatsObjects?["myImageURL"]
                let boatKey   = boatsObjects?["Key"]
                let boatAval  = boatsObjects?["Available"]
                let boaLocation = boatsObjects?["Location"]
                let boatType = boatsObjects?["Type"]
                let boatDesc = boatsObjects?["Desc"]
                let boatPhoneNumber = boatsObjects?["phoneNumber"]
                
                //creating boat object with model and fetched values
                let boat = BoatLocal(image: boatImage as! String, price: boatPrice as! String, owner: boatOwner as! String, capacity: boatCapacity as! String, model: boatModel as! String, key: boatKey as! String, avability: boatAval as! String, type: boatType as! String, location: boaLocation as! String, desc: boatDesc as! String, phoneNumber: boatPhoneNumber as! String)
                
                //appending it to list
                myBoatsArray.append(boat)
            }
            
           
        }
         return myBoatsArray
    }
    func retrieveArrayOfImages(boatKey: String,completation: @escaping ([String]) -> ()){
        var imagesArray : [String] = []
       let  refImages = FIRDatabase.database().reference().child("Bd").child("Images")
        let query = refImages.queryOrdered(byChild: "ImagePost").queryEqual(toValue: boatKey)
        
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            
            imagesArray = []
            
            if snapshot.childrenCount > 0 {
                print(snapshot.children)
                for images in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let imagesObjects = images.value as? [String: AnyObject]
                    let imageURL = imagesObjects?["ImageURL"] as? String
                    
//                    self.downImage(imgUrl: imageURL!, completation: { (image) in
//                          imagesArray.append(image)
//                    })
                    
                    imagesArray.append(imageURL!)
                    
                
                }
                completation(imagesArray)
            }
            
        })
        
    }
    func extractLocationsFromFirebase(completation: @escaping ([String]) -> ()){
        var locationsArray : [String] = []

                refPosts = FIRDatabase.database().reference().child("Bd").child("Posts")
        let query = refPosts.queryOrdered(byChild: "Available").queryEqual(toValue: "Yes")
        
          query.observe(FIRDataEventType.value, with: { (snapshot) in
            
            locationsArray = []
            
            if snapshot.childrenCount > 0 {
            
                for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                    let boatsObjects = boats.value as? [String: AnyObject]
                    let boatLocation = boatsObjects?["Location"]
                    
                    locationsArray.append(boatLocation as! String)
                                   
                }
                    completation(locationsArray)
            
            }
            
        })
        
    }
    
    //MARK: Add Post
   
    func uploadMedia(image : UIImage ,completion: @escaping (_ url: String?) -> Void) {
        let storageRef = FIRStorage.storage().reference().child(UUID().uuidString)
        if let uploadData = UIImagePNGRepresentation(image) {
            storageRef.put(uploadData, metadata: nil) { (metadata, error) in
                if error != nil {
                    print("error")
                    completion(nil)
                } else {
                    completion((metadata?.downloadURL()?.absoluteString)!)
                    // your uploaded photo url.
                }
            }
        }
    }
    
    func addPostUpdated(boat: BoatLocal){
        
        let ref = FIRDatabase.database().reference(withPath: "Bd")
//        let key = UUID().uuidString
//        uploadMedia(image: images[0]) { url in
//            if url != nil {
        
                ref.child("Posts").childByAutoId().setValue([
                    "Model"      : boat.model,
                    "Price"    : boat.price,
                    "Capacity"     : boat.capacity,
                    "Owner"        : boat.owner,
                    "myImageURL" : boat.image,
                    "Key"        : boat.key,
                    "Available"  : "Yes",
                    "Location"   : boat.location,
                    "Type"       : boat.type,
                    "Desc"       : boat.desc,
                    "phoneNumber" : boat.phoneNumber
                    
                    
                    ])
                           }
    


        

    
    func addPost (model : String ,price : String , capacity : String ,images : [UIImage] ,location : String , type : String,desc : String , phoneNumber : String){
        let ref = FIRDatabase.database().reference(withPath: "Bd")
          let key = UUID().uuidString
        uploadMedia(image: images[0]) { url in
           if url != nil {
      
        ref.child("Posts").childByAutoId().setValue([
                    "Model"      : model,
                    "Price"    : price,
                    "Capacity"     : capacity,
                    "Owner"        : FIRAuth.auth()?.currentUser?.email,
                   "myImageURL" : url!,
                    "Key"        : key,
                    "Available"  : "Yes",
                    "Location"   : location,
                    "Type"       : type,
                    "Desc"       : desc,
                    "phoneNumber" : phoneNumber
                    
                    
                    ])
       
            }
        }
         addArrayofImages(images: images, key: key)
    }
    
    func addArrayofImages(images: [UIImage],key: String){
        let ref = FIRDatabase.database().reference(withPath: "Bd")
        for image in images{
            uploadMedia(image: image, completion: { (url) in
                if url != nil {
                    ref.child("Images").childByAutoId().setValue([
                        "ImagePost" : key,
                        "ImageURL"  : url
                        ])
                }
            })
        }
    }
    
    
    //MARK: Login
    func login (email : String , password : String, completion:@escaping (String) -> ()){
       
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("Invalid Email")
                        completion("invalid email")
                        case .errorCodeWrongPassword:
                        print("wrong pass")
                        completion("Invalid Password")
                        
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                
                print(error!)
               // completion(false)
            }
            else {
                completion("Succes")
                print("login successful")
                         }
        })
       
    }
    //MARK: Register
    func register (email : String , password : String,completation: @escaping (String) -> ()) {
       
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
            //    let errorCode = FIRAuthErrorNameKey
                
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .errorCodeInvalidEmail:
                        print("Invalid Email")
                        completation("invalid email")
                    case .errorCodeEmailAlreadyInUse:
                        print("in use")
                        completation("Email Already In Use")
                    case .errorCodeWeakPassword:
                        print("week pass")
                        completation("The password must be 6 characters long or more")
                  
                    default:
                        print("Create User Error: \(error!)")
                    }
                }
                
                print(error!)
              //completation(errorCode)
            }
            else {
                completation("Succes")
                print ("Registration Successful!")
                
                
                
            }
            
        })
        
    }
    func updateBooks(forUser email: String, completation: @escaping () -> ()){
        WebService().retrieveBooksFromFirebase { (booksFromFirebase) in
            let booksFromCoredata = CoreDataService().getBooksFromCoreData(forUser: email)
            
            if booksFromFirebase.count != booksFromCoredata.count {
                
                for book in booksFromFirebase{
                    
                    let found = booksFromCoredata.filter({ (localBook) -> Bool in
                        if localBook.BookKey == book.BookKey
                            && localBook.boatModel == book.boatModel
                            && localBook.boatOwner == book.boatOwner
                            && localBook.Client == book.Client
                            && localBook.dateEnd == book.dateEnd
                            && localBook.dateStart == book.dateStart
                            && localBook.imageUrl == book.imageUrl
                            && localBook.price == book.price{
                            return true
                        } else{
                            return false
                        }
                    })
                    
                    if found.count < 1 {
                        CoreDataService().addBookToCoreDate(book: book)
                    }
                    
                }
                
            }
            
            completation()
        }
    }
    //MARK: Update Post
    func updatePost(object : BoatLocal){
        
        
    }
    
    func changePreviewImage(boatKey: String , imageURL: String){
        refPosts = FIRDatabase.database().reference().child("Bd").child("Posts");
        
        let queryForKey = refPosts.queryOrdered(byChild: "Key").queryEqual(toValue: boatKey)
        
        queryForKey.observe(FIRDataEventType.value, with: { (snapshot) in
            
            for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
                
                let boatsObjects = boats.value as? [String: AnyObject]
                
                if boatKey == boatsObjects?["Key"] as! String{
                    let ref = self.refPosts.child(boats.key)
                    ref.updateChildValues(["myImageURL" : imageURL])
                }
                
                
            }
        })

        
    }
    
    //Mark : Delete post
    func disablePost(object :BoatLocal){
        refPosts = FIRDatabase.database().reference().child("Bd").child("Posts");
      
        let queryForKey = refPosts.queryOrdered(byChild: "Key").queryEqual(toValue: object.key)
      
        queryForKey.observe(FIRDataEventType.value, with: { (snapshot) in
          
            for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
              
                let boatsObjects = boats.value as? [String: AnyObject]
             
                if object.key == boatsObjects?["Key"] as! String{
                    let ref = self.refPosts.child(boats.key)
                    ref.updateChildValues(["Available" : "No"])
                }

           
            }
        })
        
        
    }
    
    func activatePost(object : BoatLocal){
        refPosts = FIRDatabase.database().reference().child("Bd").child("Posts");
        
        let queryForKey = refPosts.queryOrdered(byChild: "Key").queryEqual(toValue: object.key)
        
        queryForKey.observe(FIRDataEventType.value, with: { (snapshot) in
            
            for boats in snapshot.children.allObjects as! [FIRDataSnapshot] {
               
                let boatsObjects = boats.value as? [String: AnyObject]
                
                if object.key == boatsObjects?["Key"] as! String{
                    let ref = self.refPosts.child(boats.key)
                    ref.updateChildValues(["Available" : "Yes"])
                }
                
                
            }
        })
        
    }
    func dateFormat(date : String) -> (Date){
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.date(from: date)!
    
    }
    
    //MARK: Booking
   
    func newBookAdded(){
        
        
        
    }
    
    private func calculateDaysBetweenTwoDates(startDate: String, endDate: String) -> Int {
        
        let currentCalendar = Calendar.current
        guard let start = currentCalendar.ordinality(of: .day, in: .era, for: dateFormat(date: startDate)
) else {
            return 0
        }
        guard let end = currentCalendar.ordinality(of: .day, in: .era, for: dateFormat(date: endDate)) else {
            return 0
        }
        return end - start
    }
    
    func addBook(boat : BoatLocal,dateStart : String , dateEnd : String ,completation : @escaping (String) -> ()){
       
        checkBookAvability(boatKey: boat.key, dateStart: dateStart, dateEnd: dateEnd) { (result) in
            if result {
                let ref = FIRDatabase.database().reference(withPath: "Bd")
                let totalPrice = self.calculateDaysBetweenTwoDates(startDate: dateStart, endDate: dateEnd) * Int(boat.price)!
                ref.child("Books").childByAutoId().setValue([
                    "BoatKey"       : boat.key,
                    "Client"        : FIRAuth.auth()?.currentUser?.email,
                    "Price"         : String(totalPrice),
                    "DateStart"     :dateStart,
                    "DateEnd"       :dateEnd,
                    "boatOwner"     : boat.owner,
                    "boatURL"       : boat.image,
                    "boatModel"      : boat.model
                    
                    ])
                CoreDataService().addBookToCoreDate(book: BookLocal(BookKey: boat.key, Client: (FIRAuth.auth()?.currentUser?.email)!, price:  String(totalPrice), dateStart: dateStart, dateEnd: dateEnd, boatOwner: boat.owner, imageUrl: boat.image, boatModel: boat.model))
                
                    completation("Succes")
            }else{
                completation("Fail")
            }
        }
        
       
        
    }
    
    func retrieveBooksFromFirebase(completation: @escaping ([BookLocal]) -> ()){
        refPosts = FIRDatabase.database().reference().child("Bd").child("Books")
        let query = refPosts.queryOrdered(byChild: "Client").queryEqual(toValue: FIRAuth.auth()?.currentUser?.email)
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            
            completation(self.extractFromFirebaseBooks(snapshot: snapshot))
        })

        
        
    }
    func extractFromFirebaseBooks(snapshot : FIRDataSnapshot) -> [BookLocal]{
        var myBooksArray : [BookLocal] = []
        if snapshot.childrenCount > 0 {
            
            
            //iterating through all the values
            for books in snapshot.children.allObjects as! [FIRDataSnapshot] {
                //getting values
                let bookObjects = books.value as? [String: AnyObject]
                let bookKey  = bookObjects?["BoatKey"]
                let Client  = bookObjects?["Client"]
                let price = bookObjects?["Price"]
                let dateStart = bookObjects?["DateStart"]
                let dateEnd = bookObjects?["DateEnd"]
                let boatOwner = bookObjects?["boatOwner"]
                let imageUrl  = bookObjects?["boatURL"]
                let boatModel  = bookObjects?["boatModel"]
                
                //creating book object with model and fetched values
                let book = BookLocal(BookKey: bookKey as! String, Client: Client as! String, price: price as! String, dateStart: dateStart as! String, dateEnd: dateEnd as! String, boatOwner: boatOwner as!  String, imageUrl: imageUrl as! String, boatModel: boatModel as! String)
                
                //appending it to list
                myBooksArray.append(book)
            }
        }
        return myBooksArray
    }
    
    
    func retrieveMyBooksFromFirebase(MyBoat : BoatLocal,completation: @escaping ([BookLocal]) -> ()){
        refPosts = FIRDatabase.database().reference().child("Bd").child("Books")
        let query = refPosts.queryOrdered(byChild: "BoatKey").queryEqual(toValue: MyBoat.key)
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            
            completation(self.extractFromFirebaseBooks(snapshot: snapshot))
        })
        
        
        
    }
    
    func checkBookAvability(boatKey : String ,dateStart : String , dateEnd : String,completation: @escaping (Bool) -> ()) {
       
        refPosts = FIRDatabase.database().reference().child("Bd").child("Books")
        let query = refPosts.queryOrdered(byChild: "BoatKey").queryEqual(toValue: boatKey)
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            
          completation(self.extractFromFirebaseBooksForCheck(snapshot: snapshot,  dateS: dateStart, dateE: dateEnd))
        })
      //  return isOkay
    }
    
    func extractFromFirebaseBooksForCheck(snapshot : FIRDataSnapshot,dateS : String , dateE : String) -> Bool{
        var isOK : Bool = true
        if snapshot.childrenCount > 0 {
            
            
            //iterating through all the values
            for books in snapshot.children.allObjects as! [FIRDataSnapshot] {
                //getting values
                let bookObjects = books.value as? [String: AnyObject]
                let dateStart = bookObjects?["DateStart"] as! String
                let dateEnd = bookObjects?["DateEnd"] as! String
                
                if ((dateFormat(date: dateS) < dateFormat(date: dateStart)) && (dateFormat(date: dateE) < dateFormat(date: dateStart))) || ((dateFormat(date: dateS) > dateFormat(date: dateEnd)) && ( dateFormat(date: dateE) > dateFormat(date: dateEnd))){
                    
                } else {
                    isOK = false
                }
                
                
            }
        }
       // return myBooksArray
        return isOK
    }


//MARK: Chat
    func addMessageToFirebase(message : Message){
           let ref = FIRDatabase.database().reference(withPath: "Bd")
        ref.child("Messages").childByAutoId().setValue([
            "selectedBoatKey"     : message.selectedBoatKey,
            "sendDate"        : getToday(withHour: true),
            "contentOfMessage" : message.contentOfMessage,
            "SenderEmail"      : message.SenderEmail,
            "ReceiverEmail"    : message.RecevierEmail
     
            ])

    }
    
    func retrieveLastMessageFromFirebase(ReceiverEmail : String , completation : @escaping ([Message]) -> ()){
        var messageArray : [Message] = []
        var senderArray : [String] = []
        let refMessages = FIRDatabase.database().reference().child("Bd").child("Messages")
        let query = refMessages.queryOrdered(byChild: "ReceiverEmail").queryEqual(toValue: ReceiverEmail)
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            messageArray = []
            senderArray = []
            if snapshot.childrenCount > 0 {
                for msg in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let msgObject = msg.value as? [String: AnyObject]
                    
                    let selectedBoatKey = msgObject?["selectedBoatKey"] as! String
                    let sendDate  = msgObject?["sendDate"] as! String
                    let contentOfMessage = msgObject?["contentOfMessage"] as! String
                    let senderEmail = msgObject?["SenderEmail"] as! String
                    let receiverEmail = msgObject?["ReceiverEmail"] as! String
                    
                    if !senderArray.contains(senderEmail){
                        senderArray.append(senderEmail)
                        messageArray.append(Message(sendDate: sendDate, contentOfMessage: contentOfMessage, selectedBoatKey: selectedBoatKey, SenderEmail: senderEmail, RecevierEmail: receiverEmail))
                    
                    }
                }
            }
            completation(messageArray)
        })
    }
    
    func retrieveMessageFromFirebase(SenderEmail : String , ReceiverEmail : String,selectedBoatKey : String,completation : @escaping ([Message]) -> ()) {
        var myMessageArray : [Message] = []
        let refMessages = FIRDatabase.database().reference().child("Bd").child("Messages")
        let query = refMessages.queryOrdered(byChild: "selectedBoatKey").queryEqual(toValue: selectedBoatKey)
        query.observe(FIRDataEventType.value, with: { (snapshot) in
            myMessageArray = []
            if snapshot.childrenCount > 0 {
                               for msg in snapshot.children.allObjects as! [FIRDataSnapshot]{
                    let msgObject = msg.value as? [String: AnyObject]
                 //   let senderKey = msgObject?["SenderKey"] as! String
                  //  let receiverKey = msgObject?["ReceiverKey"] as! String
                    let selectedBoatKey = msgObject?["selectedBoatKey"] as! String
                    let sendDate  = msgObject?["sendDate"] as! String
                    let contentOfMessage = msgObject?["contentOfMessage"] as! String
                    let senderEmail = msgObject?["SenderEmail"] as! String
                    let receiverEmail = msgObject?["ReceiverEmail"] as! String
                   
                    if (SenderEmail == senderEmail && ReceiverEmail == receiverEmail) || (SenderEmail == receiverEmail && ReceiverEmail == senderEmail) {
                        myMessageArray.append(Message( sendDate: sendDate, contentOfMessage: contentOfMessage, selectedBoatKey: selectedBoatKey, SenderEmail: senderEmail, RecevierEmail: receiverEmail))
                              //print(myMessageArray.count)
                                }
                    }
            }
            //print(myMessageArray.count)
            completation(myMessageArray)
            /* -> Sort by date for when Date feature will be available
            completation( myMessageArray.sorted(by: { (x, y) -> Bool in
                return self.dateFormat(date: x.sendDate) < self.dateFormat(date: y.sendDate)
            }))
            */
        
        })
      //

        
    }
    //MARK: Date
    func getToday(withHour : Bool) -> String {
        let date = Date()
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        formatter.dateFormat = "dd.MM.yyyy"
        
        if withHour {
            let result = formatter.string(from: date).appending(" ".appending(String(hour).appending(":".appending(String(minute)))))
            return result
        }else {
            let result = formatter.string(from: date)
            return result
        }
    
    }
    
    //MARK: Review
    
    func addReviewToFirebase(review : Review){
         let ref = FIRDatabase.database().reference(withPath: "Bd")
        ref.child("Review").childByAutoId().setValue([
            "UserEmail" : review.userEmail,
            "Rating"    : review.rating,
            "Date"      : getToday(withHour: false),
            "ReviewContent" : review.reviewContent,
            "BoatKey"   : review.boatKey
            ])
    }
   
    func deleteReviewFromFirebase(boatKey: String){
        
    }
    
    func retrieveReviewFromFirebase(boatKey : String, completation: @escaping ([Review]) -> ()){
        var reviewArray : [Review] = []
        let refReviews = FIRDatabase.database().reference().child("Bd").child("Review")
        let query = refReviews.queryOrdered(byChild: "BoatKey").queryEqual(toValue: boatKey)
        
        query.observe(FIRDataEventType.value, with: { (snapshot) in
      
            reviewArray = []
            if snapshot.childrenCount > 0 {
            
              for rev in snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                let revObject = rev.value as? [String : AnyObject]
                let userEmail = revObject?["UserEmail"] as! String
                let rating = revObject?["Rating"] as! Double
                let date = revObject?["Date"] as! String
                let reviewContent = revObject?["ReviewContent"] as! String
                let reviewedBoatKey = revObject?["BoatKey"] as! String
                
                reviewArray.append(Review(userEmail: userEmail, rating: rating, date: date, reviewContent: reviewContent, boatKey: reviewedBoatKey))
                }
            }
        
            completation(reviewArray)
        })
    }
    
}
