//
//  RegVC.swift
//  Boats
//
//  Created by Absolute Mac on 12/06/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
class RegVC: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var conPassTxt: UITextField!
   
    @IBAction func createUserPressed(_ sender: Any) {
        
       
        guard let email =  emailTextField!.text, !email.isEmpty else {
        AlertService().showAlert(mesaj: "Enter an Email", withCurentVC: self)
            return
        }
        
        guard let pass = passwordTextField!.text ,!pass.isEmpty else {
            AlertService().showAlert(mesaj: "Enter a Password", withCurentVC: self)

            
            return
        }
        
        guard let conn = conPassTxt!.text, !conn.isEmpty else {
             AlertService().showAlert(mesaj: "Enter the second password", withCurentVC: self)
                    return
        }
        
        if pass == conn{
            let alertLoading  = AlertCustom().LoadingAlert()
            present(alertLoading, animated: true, completion: nil)

            WebService().register(email: email, password: pass, completation: {
                rez in
                if rez  == "Succes" {
                  
                    self.navigationController?.popViewController(animated: true)
                      alertLoading.dismiss(animated: false, completion: nil)
                } else{
                   alertLoading.dismiss(animated: false, completion: nil)
                    AlertService().showAlert(mesaj: rez, withCurentVC: self)
                                  }
            })

        }else {
            AlertService().showAlert(mesaj: "Passwords don't match", withCurentVC: self)
            print("wrong con pass")
        }
        
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        makeMeDelegate()
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
           }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    }
extension RegVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func makeMeDelegate(){
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
}

