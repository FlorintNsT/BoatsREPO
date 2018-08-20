//
//  AlertService.swift
//  Boats
//
//  Created by Absolute Mac on 10/08/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import UIKit
class AlertService {
   
    func showAlert(mesaj : String,withCurentVC viewController: UIViewController ){
        let alert = UIAlertController(title: mesaj, message: nil, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
