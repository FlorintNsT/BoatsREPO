//
//  DiskService.swift
//  Boats
//
//  Created by Absolute Mac on 26/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import UIKit

class DiskService{

    func getImageFromDisk(imageDiskURL: String) -> UIImage{
      
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
         let imageURL = docDir.appendingPathComponent(imageDiskURL)
        
        let newImage = UIImage(contentsOfFile: imageURL.path)!
        return newImage
    }
    
    func addImageToDisk(image: UIImage) -> String{
        let imageData = UIImagePNGRepresentation(image)!
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let uuid = UUID().uuidString
        let imageURL = docDir.appendingPathComponent(uuid)
        try! imageData.write(to: imageURL)
        
        return uuid
        
    }
    func deleteImageFromDisk(imageDiskURL: String){
        let docDir = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let imageURL = docDir.appendingPathComponent(imageDiskURL)
      try! FileManager.default.removeItem(at: imageURL)

    }
}
