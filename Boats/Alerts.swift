//
//  Alerts.swift
//  Boats
//
//  Created by Absolute Mac on 16/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import Foundation
import UIKit
class AlertCustom {
    func LoadingAlert() -> UIAlertController{
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        alert.view.addSubview(loadingIndicator)
        
        return alert
        // present(alert, animated: true, completion: nil)
    }

}
