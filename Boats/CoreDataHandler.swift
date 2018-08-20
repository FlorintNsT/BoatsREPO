//
//  CoreDataHandler.swift
//  Boats
//
//  Created by Absolute Mac on 12/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import CoreData
class CoreDataHandler{
     var managedContext : NSManagedObjectContext?
    
    
//    func savaUserToCoreData(newEmail : String , newPassword :String){
//        
//        self.managedContext = AppDelegate().persistentContainer.viewContext
//        
//        guard let moc = self.managedContext else {
//            return
//        }
//        
//        
//        guard let user = NSEntityDescription.insertNewObject(forEntityName: "User", into: moc) as? User else{
//            // handle failed new object in moc
//            print("moc error")
//            return
//        }
//        
//        user.email = newEmail
//        user.password = newPassword
//        
//        do {
//            try moc.save()
//        } catch {
//            fatalError("Failure to save context: \(error)")
//            
//        }
//
//        
//    }
    func retrieveUsersFromCoreData() -> [String : String]{
        self.managedContext = AppDelegate().persistentContainer.viewContext
        //guard
            let moc = self.managedContext //else {
           // return nil
       // }
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        let sortDescriptor = NSSortDescriptor(key: "email", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        var userDict = [String : String]()
        do {
            let results = try moc?.fetch(fetchRequest) as! [NSManagedObject]
            
            for result in results {
                userDict[(result.value(forKey: "email") as? String)!] = result.value(forKey:"password") as? String
             //   let userR = Item(imgId: result.value(forKey: "image") as! String, catg: result.value(forKey: "catg") as! Int)
               // list.append(itemT)
                
            }
        } catch {
            print(error)
            //return nil
        }
        
        return userDict

        
    }
    //func retriveBoatsFromCoreData()
    func addBoatToCoreData(){
        
    }
    //func deleteBoatFromCoreData()
    // func addBookInCoreData()
}
