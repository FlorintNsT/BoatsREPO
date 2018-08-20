//
//  LogVC.swift
//  Boats
//
//  Created by Absolute Mac on 12/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import UserNotifications
class LogVC: UIViewController ,UNUserNotificationCenterDelegate{

    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
//    
    var mailTest = "a@a.com"
    var passTest = "123456"
//    var mailTest = "test@test.com"
//     var passTest = "testtest"
    @IBAction func logBtnPressed(_ sender: Any) {
    
        
        guard let email = emailTextField!.text , !email.isEmpty else {
            
             AlertService().showAlert(mesaj: "Enter the Email", withCurentVC: self)
            return
        }
        
        guard let pass = passwordTextField!.text , !pass.isEmpty else {
            
            UIViewAn
            
            AlertService().showAlert(mesaj: "Enter the Password", withCurentVC: self)
                      return
        }
        let alertLoading  = AlertCustom().LoadingAlert()
        present(alertLoading, animated: true, completion: nil)

        WebService().login(email: email, password: pass, completion: { rez in
            if rez == "Succes" {
               // self.navigationController?.navigationBar.isHidden = true
                
                WebService().updateBooks(forUser: email, completation: { 
                    alertLoading.dismiss(animated: false, completion: {
                     //   NotificationService().showNotif(withTitle: "Log Test", withMessage: "test")
//                        self.performSegue(withIdentifier: "segueBoats", sender: self)
                      
                        
                        let BoatVC = self.storyboard?.instantiateViewController(withIdentifier: "TabBarBoats") as! UITabBarController
                        self.present(BoatVC, animated: true, completion: nil)
                        
                    })
                    
                })
//                alertLoading.dismiss(animated: false, completion: nil)
            } else{
               alertLoading.dismiss(animated: false, completion: nil)
                 AlertService().showAlert(mesaj: rez, withCurentVC: self)
                            }

        })
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
           
        
            makeMeDelegate()
            emailTextField.text = mailTest
            passwordTextField.text = passTest
            hideKeyboardWhenTappedAround()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //displaying the ios local notification when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
    
   

    
    
    func observeNewBookAdded(){
        
        
    }
    
    }
extension LogVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func makeMeDelegate(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}
