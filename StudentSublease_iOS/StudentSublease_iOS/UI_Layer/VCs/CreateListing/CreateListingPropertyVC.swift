//
//  CreateListingPropertyVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingPropertyVC: UIViewController {
    
    @IBAction func cbackClick(_ sender: Any) {
    print("here")
    }

    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet var numBedsTextField: UITextField!
    @IBOutlet var numBathsTextField: UITextField!
    @IBOutlet var numTenantsTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    var street: String!
    var city: String!
    var state: String!
    var zip: String!
    
    var numBed: Int!
    var numBath: Double!
    var numTenants: Int!
    
    var startDate: String! = ""
    var endDate: String! = ""
    var rentPerMonth: Int = 0
    var fees: Int = 0
    var titleField: String! = ""
    var descriptionField: String! = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.layer.cornerRadius = 8.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))

        
        print("BATHH: " , numBath)
        print("BEDDD: " , numBed)
        print("BATHH: " , numTenants)
        
        
        if numBed != nil{
            numBedsTextField.text = String(numBed)
        }
        if numBath != nil{
            numBathsTextField.text = String(numBath)

        }
        if numTenants != nil{
            numTenantsTextField.text = String(numTenants)
        }
        
        
    }
    @objc func addTapped(){
        performSegue(withIdentifier: "back", sender: self)
    }
    @objc func onClose(){
        print("here")
        self.dismiss(animated: true, completion: nil)
    }
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if numBedsTextField.text == "" ||  numBathsTextField.text == "" || numTenantsTextField.text == ""{
            error.text = "Please fill out all fields"
        }
        else if (numTenantsTextField.text?.contains("."))! {
            error.text = "Please enter an appropriate number of tenants"
        }
        else{
        
        self.performSegue(withIdentifier: "createSublease", sender: self)
        }
    }
    
    @IBAction func amenityButtonClicked(_ sender: UIButton) {
        let unselectedImage = UIImage(systemName: "circle")
        let selectedImage = UIImage(systemName: "circle.fill")
        if sender.currentBackgroundImage == unselectedImage {
            sender.setBackgroundImage(selectedImage, for: .normal)
        } else {
            sender.setBackgroundImage(unselectedImage, for: .normal)
        }
    }
   
    
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        print("here111")
           if let destination = unwindSegue.destination as? CreateListingAddressVC {
                print("ohdhvoshdvoshdohsvd")
               destination.street = self.street
               destination.city = self.city
               destination.state = self.state
               destination.zip = self.zip
               destination.numBed = Int(self.numBedsTextField.text!)
               destination.numBath = Double(self.numBathsTextField.text!)
               destination.numTenants = Int(self.numTenantsTextField.text!)
               destination.startDate = self.startDate
               destination.endDate = self.endDate
            destination.rentPerMonth = self.rentPerMonth
            destination.fees = self.fees
               destination.titleField = self.titleField
               destination.descriptionField = self.descriptionField
           }
       }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("oiiii")
        if segue.identifier == "createSublease" {
            if let destination = segue.destination as? CreateListingSubleaseVC {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                destination.numBed = Int(self.numBedsTextField.text!)
                destination.numBath = Double(self.numBathsTextField.text!)
                destination.numTenants = Int(self.numTenantsTextField.text!)
                destination.street = self.street!
                destination.city = self.city!
                destination.state = self.state!
                destination.zip = self.zip!
                destination.startDate = self.startDate
                destination.endDate = self.endDate
                destination.rentPerMonth = self.rentPerMonth
                destination.fees = self.fees
                destination.titleField = self.titleField
                destination.descriptionField = self.descriptionField
                
            }
        }
        if segue.identifier == "back"{
        
        if let destination = segue.destination as? CreateListingAddressVC {
            print("ohdhvoshdvoshdohsvd")
                          destination.street = self.street
                          destination.city = self.city
                          destination.state = self.state
                          destination.zip = self.zip
                          destination.numBed = Int(self.numBedsTextField.text!)
                          print("numBED: " , destination.numBed)
                          destination.numBath = Double(self.numBathsTextField.text!)
                          destination.numTenants = Int(self.numTenantsTextField.text!)
                          destination.startDate = self.startDate
                          destination.endDate = self.endDate
                          destination.rentPerMonth = self.rentPerMonth
                          destination.fees = self.fees
                          destination.titleField = self.titleField
                          destination.descriptionField = self.descriptionField
            
        }
        }
    }

}
