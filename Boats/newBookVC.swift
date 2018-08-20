//
//  newBookVC.swift
//  Boats
//
//  Created by Absolute Mac on 16/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

class newBookVC: UIViewController {
    
    //MARK: Variables 
    var selectedBoat : BoatLocal?
    
    //MARK: Outlets
    
    @IBOutlet weak var startDateTextField: UITextField!
    
    @IBOutlet weak var endDateTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureTextFields()
        hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func bookBtnPressed(_ sender: Any) {
   
        guard let startDate = startDateTextField!.text , !startDate.isEmpty else {
            showAlert(mesaj: "Select First Date")
            return
        }
        
        guard let endDate = endDateTextField!.text , !endDate.isEmpty else {
            showAlert(mesaj: "Select End Date")
            return
        }
        WebService().addBook(boat: selectedBoat!, dateStart: startDate, dateEnd: endDate, completation: {
            result in
            if result == "Fail" {
                self.showAlert(mesaj: "Selected Period is Unavailable ")
            }else {
                
                
                self.showAlert(mesaj: "Succes")
               
            }
            
        })
        
    }
    
    
    func configureTextFields(){
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        
        //done button & cancel button
        
        let cancelButton = UIBarButtonItem(title: "Close", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
        
        toolbar.setItems([cancelButton], animated: false)
        
        let datePickerView2:UIDatePicker = UIDatePicker()
        
        datePickerView2.datePickerMode = UIDatePickerMode.date
        
        startDateTextField.inputAccessoryView = toolbar
        startDateTextField.inputView = datePickerView
        endDateTextField.inputAccessoryView = toolbar
        endDateTextField.inputView = datePickerView2
        
        
         datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged1), for: UIControlEvents.valueChanged)
        
        datePickerView2.addTarget(self, action: #selector(self.datePickerValueChanged2), for: UIControlEvents.valueChanged)

        
}
    @IBAction func startDateTxt(_ sender: UITextField) {
    
//        let datePickerView:UIDatePicker = UIDatePicker()
//        
//        datePickerView.datePickerMode = UIDatePickerMode.date
//        
//        
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        
//        //done button & cancel button
//       
//               let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(cancelDatePicker))
//       
//        toolbar.setItems([cancelButton], animated: false)
        
        // add toolbar to textField
//        sender.inputAccessoryView = toolbar
//
//        
//        
//        sender.inputView = datePickerView
        
//        if sender.tag == 1 {
//        datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged1), for: UIControlEvents.valueChanged)
//        } else if sender.tag == 2 {
//            datePickerView.addTarget(self, action: #selector(self.datePickerValueChanged2), for: UIControlEvents.valueChanged)
//
//        }
        
    }

    func cancelDatePicker(){
        //cancel button dismiss datepicker dialog
        self.view.endEditing(true)
    }
    
    func datePickerValueChanged1(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        startDateTextField.text = formatter.string(from: sender.date)
        
    }


    func datePickerValueChanged2(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        
        endDateTextField.text = formatter.string(from: sender.date)
        
    }

    func showAlert(mesaj : String){
        let alert = UIAlertController(title: mesaj, message: nil, preferredStyle: UIAlertControllerStyle.alert)
       // alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: nil))
       alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.cancel, handler: { (alert) in
         self.navigationController?.popViewController(animated: true)
       }))
        self.present(alert, animated: true, completion: nil)
    }

}
