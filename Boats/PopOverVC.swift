//
//  PopOverVC.swift
//  Boats
//
//  Created by Absolute Mac on 18/07/2018.
//  Copyright © 2018 Absolute Mac. All rights reserved.
//

import UIKit

protocol PopOverVCDelegate {
    func sendLocation(location : String)
    func sendNumberOfCell(number: Int)
}

class PopOverVC: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    //MARK: Vars And Lets
    var locationsArray : [String] = []{
        didSet {
            tableView.reloadData()
             numberOfCell =  tableView.rowsCount
        }
    }
    
    var numberOfCell: Int?{
        didSet{
            delegate?.sendNumberOfCell(number: numberOfCell!)
        }
    }
    var delegate : PopOverVCDelegate?
    
    
    //MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    //MARK: View Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
       // tableView.dropShadow()
         tableView.register(UINib(nibName: "PopOverCell", bundle: nil) , forCellReuseIdentifier: "popOverCellID")
        
//        numberOfCell =  tableView.rowsCount
        
//        WebService().extractLocationsFromFirebase { (result) in
//            self.locationsArray = result
//            //print(self.locationsArray.count)
//            self.tableView.reloadData()
//        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 //MARK: TableView Funcs
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "popOverCellID",for : indexPath) as! PopOverCell
        print(locationsArray[indexPath.row])
        cell.configureCell(withText: locationsArray[indexPath.row])
        return cell
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locationsArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("show show show")
        print(locationsArray[indexPath.row])
        
        delegate?.sendLocation(location: locationsArray[indexPath.row].capitalized)
    }
    
    
    //MARK: Update TableView
    
//    func updateContent(content : String){
//        locationsArray = arrayFromFirebase.filter({ (x : String) -> Bool in
//            return x.lowercased().contains(content.lowercased())
//        })
//        tableView.reloadData()
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
