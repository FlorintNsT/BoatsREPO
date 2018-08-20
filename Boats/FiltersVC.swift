//
//  FiltersVC.swift
//  Boats
//
//  Created by Absolute Mac on 26/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

protocol FiltersVCDelegate {
    func sendFilter(filterReceive : Filter)
}


class FiltersVC: UIViewController, PopOverVCDelegate , UIPopoverPresentationControllerDelegate {

  
    //MARK: Outlets
    
    
    @IBOutlet weak var containerHeight: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var locationTxt: UITextField!
    
    @IBOutlet weak var maxCapacityTxt: UITextField!
    @IBOutlet weak var minCapacityTxt: UITextField!
    
    @IBOutlet weak var minPriceTxt: UITextField!
    
    @IBOutlet weak var maxPriceTxt: UITextField!
   
    @IBAction func filterSend(_ sender: Any) {
        delegate?.sendFilter(filterReceive: formatFilter())
        navigationController?.popViewController(animated: true)
    }
    //MARK: Load funcs
    override func viewDidLoad() {
        super.viewDidLoad()
//            hideKeyboardWhenTappedAround()
            loadCurrentFilter()
            makeMeDelegate()
        
            containerHeight.constant = 0
            containerView.dropShadow()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Delegate
    var currentFilter : Filter?
    var delegate : FiltersVCDelegate?
    var PopOverVC : PopOverVC?
    
    //Mark: Funcs
    
    func sendNumberOfCell(number: Int) {
       
        if number == 0 {
            hidePopOver()
        } else {
             containerHeight.constant = CGFloat(number * 35)
        }
       
    }
    
    func formatFilter() -> Filter{
       
       
        return Filter(location: locationTxt.text!, MinPrice: minPriceTxt.text!, MaxPrice: maxPriceTxt.text!, minCapacity: minCapacityTxt.text!, maxCapacity: maxCapacityTxt.text!)
    }

    func loadCurrentFilter(){
        locationTxt.text = currentFilter?.location
        minPriceTxt.text = currentFilter?.MinPrice
        maxPriceTxt.text = currentFilter?.MaxPrice
        minCapacityTxt.text = currentFilter?.minCapacity
        maxCapacityTxt.text = currentFilter?.maxCapacity
    }


    //MARK: PopOver funcs
    
    func sendLocation(location: String) {
        self.view.endEditing(true)

        locationTxt.text = location
       
        
    }
    
    func showPopOver() {
       if self.containerHeight.constant == 0 {
       
        UIView.animate(withDuration: 0.2) {
         //   self.containerHeight.constant = 160
            self.view.layoutIfNeeded()
            
            }
        }
    }
    func hidePopOver(){
//        if self.containerHeight.constant == 160 {
        
            UIView.animate(withDuration: 0.2) {
                self.containerHeight.constant = 0
                self.view.layoutIfNeeded()
                
            }
//        }
    }
//
//    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
//        return .none
//    }

    func getLocationArray(text : String, completation: @escaping ([String]) -> ())  {
        var locationArray : [String] = []
        
        WebService().extractLocationsFromFirebase { (result) in
            locationArray = result
            
            if text != "" {
                locationArray = locationArray.filter({ (x : String) -> Bool in
                    return x.lowercased().contains(text.lowercased())
                })
            }
           completation(locationArray)
        }
        
        }
}

extension FiltersVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
       
        if textField.tag == 1 {
            hidePopOver()
            
        }
        
        return false
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        if textField.tag == 1 {
//          showPopOver()
//       }
//    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       
        if textField.tag == 1 {
            
            showPopOver()
            
            let textFieldText = textField.text?.lowercased()
            
            var text : String {
                if string != "" {
                    return textFieldText! + string
                }
                else {
                    return textFieldText!.substring(to: textFieldText!.index(before: textFieldText!.endIndex))
                }
            }
            
           // showPopOver()
            
            getLocationArray(text: text, completation: { (result) in
                self.PopOverVC?.locationsArray = result
            })
            
//            PopOverVC?.locationsArray = getLocationArray(text: (textField.text?.lowercased())!)
        }
        
        return true
    }
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        
//    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.tag == 1 {
            hidePopOver()
        }
    }
    func makeMeDelegate(){
        locationTxt.delegate = self
        maxCapacityTxt.delegate = self
        minCapacityTxt.delegate = self
        minPriceTxt.delegate = self
        maxPriceTxt.delegate = self
    }
    //Mark: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seguePopOver"{
             PopOverVC = segue.destination as? PopOverVC
            PopOverVC?.delegate = self
        }
    }

  //MARK: Keyboard Funcs
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        guard let location = touch?.location(in: self.view) else {return}
        if !containerView.frame.contains(location){
             self.view.endEditing(true)
        }
    }
    
}

