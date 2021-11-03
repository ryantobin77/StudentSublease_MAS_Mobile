//
//  CreateListingAddressVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingAddressVC: UIViewController {
    @IBOutlet weak var error: UILabel!
    
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    var street: String!
    var city: String!
    var state: String!
    var zip: String!
    
    var numBed: Int!
    var numBath: Double!
    var numTenants: Int!
    
    var startDate: String!
    var endDate: String!
    var rentPerMonth = 0
    var fees = 0
    
    var titleField: String!
    var descriptionField: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.layer.cornerRadius = 8.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        print("BATHH12333: " , numBath)
        print("BEDDD: " , numBed)
        print("BATHH: " , numTenants)
        
        if street != "" {
            streetTextField.text = street
        }
        if city != "" {
            cityTextField.text = city
            
        }
        if state != "" {
            stateTextField.text = state
            
        }
        if zip != "" {
            zipTextField.text = zip
            
        }
        
        
    }
    
    @objc func addTapped(){
        performSegue(withIdentifier: "back1", sender: self)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if streetTextField.text == "" ||  cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "" {
            error.text = "Please fill out all fields"
        }
        else{
        self.performSegue(withIdentifier: "createProperty", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        
        if segue.identifier == "createProperty" {
            if let destination = segue.destination as? CreateListingPropertyVC {
                destination.street = self.streetTextField.text!
                destination.city = self.cityTextField.text!
                destination.state = self.stateTextField.text!
                destination.zip = self.zipTextField.text!
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.numTenants = self.numTenants
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
