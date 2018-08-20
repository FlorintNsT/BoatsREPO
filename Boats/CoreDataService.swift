//
//  CoreDataService.swift
//  Boats
//
//  Created by Absolute Mac on 26/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import FirebaseAuth
class CoreDataService{
    
    var managedContext : NSManagedObjectContext?
    
    //Mark: Image
    func addImageObjectToCoreData(imageURL: String,img: UIImage){
        
        //add in on disk to get imageDiskURl
        //save imageObject
        
        self.managedContext = AppDelegate().persistentContainer.viewContext
        
        guard let moc = self.managedContext else {
            return
        }
       
        guard let image = NSEntityDescription.insertNewObject(forEntityName: "Image", into: moc) as? Image else{
            // handle failed new object in moc
            print("moc error")
            return
        }
        image.imageURL = imageURL
        
        image.imageDiskURL =  DiskService().addImageToDisk(image: img)
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
            
        }
    
    }
    
    func addBookToCoreDate(book: BookLocal){
       
        self.managedContext = AppDelegate().persistentContainer.viewContext
        
        guard let moc = self.managedContext else {
            return
        }
        
        guard let bookObject = NSEntityDescription.insertNewObject(forEntityName: "BookObject", into: moc) as? BookObject else{
            // handle failed new object in moc
            print("moc error")
            return
        }
        
        bookObject.boatKey = book.BookKey
        bookObject.boatModel = book.boatModel
        bookObject.boatOwner = book.boatOwner
        bookObject.boatURL = book.imageUrl
        bookObject.client = book.Client
        bookObject.dateEnd = book.dateEnd
        bookObject.dateStart = book.dateStart
        bookObject.price = book.price
        
        do {
            try moc.save()
        } catch {
            fatalError("Failure to save context: \(error)")
            
        }
        
    }
    func getBooksFromCoreData(forUser email: String) -> [BookLocal] {
        
        var booksArray: [BookLocal] = []
        self.managedContext = AppDelegate().persistentContainer.viewContext
        //guard
        let moc = self.managedContext //else {
        // return nil
        // }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BookObject")
        let sortDescriptor = NSSortDescriptor(key: "client", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "client = %@", email)
        
        do {
            let results = try moc?.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
                
                let book = BookLocal(BookKey: result.value(forKey: "boatKey") as! String,
                                     Client: result.value(forKey: "client") as! String,
                                     price: result.value(forKey: "price") as! String,
                                     dateStart: result.value(forKey: "dateStart") as! String,
                                     dateEnd: result.value(forKey: "dateEnd") as! String,
                                     boatOwner: result.value(forKey: "boatOwner") as! String,
                                     imageUrl: result.value(forKey: "boatURL") as! String,
                                     boatModel: result.value(forKey: "boatModel") as! String)
                
                booksArray.append(book)
            }
        } catch {
            print(error)
            //return nil
        }
        
        return booksArray
    }
    

    func tryGetImageFromDisk(imageURL: String) -> UIImage?{
    
        //if can't get it . addImageObjectToCoreData()
        var FinalImage : UIImage?
        
        self.managedContext = AppDelegate().persistentContainer.viewContext
        //guard
        let moc = self.managedContext //else {
        // return nil
        // }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        let sortDescriptor = NSSortDescriptor(key: "imageURL", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        
        var ImageDict = [String : String]()
        do {
            let results = try moc?.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
                ImageDict[(result.value(forKey: "imageURL") as? String)!] = result.value(forKey:"imageDiskURL") as? String
                //   let userR = Item(imgId: result.value(forKey: "image") as! String, catg: result.value(forKey: "catg") as! Int)
                // list.append(itemT)
                
            }
        } catch {
            print(error)
            //return nil
        }
        
        if let val = ImageDict[imageURL] {
            // now val is not nil and the Optional has been unwrapped, so use it
           FinalImage = DiskService().getImageFromDisk(imageDiskURL: val)
        }
        
        return FinalImage
        
    }

    
    func updateCoreData(){
        // search every row in firebase , if a row it is not in firebase -> delete rOw
        // call in launch screen
  
        self.managedContext = AppDelegate().persistentContainer.viewContext
        //guard
        let moc = self.managedContext //else {
        // return nil
        // }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        let sortDescriptor = NSSortDescriptor(key: "imageURL", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var ImageArray = [String]()
        do {
            let results = try moc?.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
//                ImageDict[(result.value(forKey: "imageURL") as? String)!] = result.value(forKey:"imageDiskURL") as? String
                //   let userR = Item(imgId: result.value(forKey: "image") as! String, catg: result.value(forKey: "catg") as! Int)
                // list.append(itemT)
                ImageArray.append((result.value(forKey: "imageURL") as? String)!)
            }
        } catch {
            print(error)
            //return nil
        }
        
        for url in ImageArray{
            WebService().iSImageUrlInFirebase(imageURL: url, completation: { (isInDB) in
                if !isInDB {
                    self.deleteFromCoreData(imageURL: url)
                }
            })
        }
        
       
    }
    
    func deleteFromCoreData(imageURL: String){
        self.managedContext = AppDelegate().persistentContainer.viewContext
        //guard
        let moc = self.managedContext //else {
        // return nil
        // }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Image")
        let sortDescriptor = NSSortDescriptor(key: "imageURL", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = NSPredicate(format: "imageURL = %@", imageURL)
        
        
        do {
            let results = try moc?.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
              
                moc?.delete(result)
                DiskService().deleteImageFromDisk(imageDiskURL: (result.value(forKey: "imageDiskURL") as? String)! )
            }
        } catch {
            print(error)
            //return nil
        }
      
        do {
            try moc?.save()
        } catch {
            fatalError("Failure to save context: \(error)")
            
        }
        
        
    }
    //Mark: books

}
