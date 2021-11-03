//
//  CreateListingSubleaseVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingSubleaseVC: UIViewController {
    @IBAction func backButton(_ sender: Any) {
        print("hereeee")
    }
    @IBOutlet weak var error: UILabel!
    @IBOutlet weak var back: UIBarButtonItem!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var rentTextField: UITextField!
    @IBOutlet var feesTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    var numBed: Int!
    var numBath: Double!
    var numTenants: Int!
    var street: String!
    var city: String!
    var state: String!
    var zip: String!
    var startDate: String! = ""
    var endDate: String! = ""
    var rentPerMonth: Int! = -1
    var fees: Int! = -1
    var titleField: String! = ""
    var descriptionField: String! = ""
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.layer.cornerRadius = 8.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(addTapped))
        self.view.addGestureRecognizer(tap)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        print("startDate: " , startDate)
        if startDate != nil {
            startDatePicker.date = dateFormatter.date(from: startDate)!
        }
        if endDate != nil{
            endDatePicker.date = dateFormatter.date(from: endDate)!
        }
        if String(rentPerMonth) != nil && rentPerMonth > -1{
            rentTextField.text = String(rentPerMonth)
        }
        
        if String(fees) != nil && fees > -1{
            feesTextField.text = String(fees)
        }
        
        
        
        
        
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    @objc func addTapped(){
        performSegue(withIdentifier: "back1", sender: self)
    }
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if rentTextField.text == "" ||  feesTextField.text == ""{
                   error.text = "Please fill out all fields"
               }

               else{
               
        self.performSegue(withIdentifier: "createFinal", sender: self)
        }
    }
    override func unwind(for unwindSegue: UIStoryboardSegue, towards subsequentVC: UIViewController) {
        if let destination = unwindSegue.destination as? CreateListingPropertyVC {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            destination.street = self.street
            destination.city = self.city
            destination.state = self.state
            destination.zip = self.zip
            destination.numBed = self.numBed
            destination.numBath = self.numBath
            destination.numTenants = self.numTenants
            destination.startDate = dateFormatter.string(from: self.startDatePicker.date)
            destination.endDate = dateFormatter.string(from: self.endDatePicker.date)
            destination.rentPerMonth = Int(rentTextField.text!) ?? 0
            destination.fees = Int(self.fees) ?? 0
            destination.titleField = self.titleField
            destination.descriptionField = self.descriptionField
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFinal" {
            if let destination = segue.destination as? CreateListingFinalVC {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                destination.startDate = dateFormatter.string(from: self.startDatePicker.date)
                destination.endDate = dateFormatter.string(from: self.endDatePicker.date)
                destination.rentPerMonth = Int(self.rentTextField.text!)
                destination.fees = Int(self.feesTextField.text!)
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.numTenants = self.numTenants
                destination.street = self.street
                destination.city = self.city
                destination.state = self.state
                destination.zip = self.zip
                destination.titleField = self.titleField
                destination.descriptionField = self.descriptionField
            }
        }
        
        if segue.identifier == "back1" {
            if let destination = segue.destination as? CreateListingPropertyVC {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                destination.street = self.street
                destination.city = self.city
                destination.state = self.state
                destination.zip = self.zip
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.numTenants = self.numTenants
                destination.startDate = dateFormatter.string(from: self.startDatePicker.date)
                destination.endDate = dateFormatter.string(from: self.endDatePicker.date)
                destination.rentPerMonth = Int(rentTextField.text!) ?? 0
                destination.fees = Int(self.fees) ?? 0
                destination.titleField = self.titleField
                destination.descriptionField = self.descriptionField
            }
            
        }
        
    }
    
}
