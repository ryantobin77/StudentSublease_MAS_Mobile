//
//  CreateListingSubleaseVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingSubleaseVC: UIViewController {
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.layer.cornerRadius = 8.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "createFinal", sender: self)
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
                destination.street = self.street!
                destination.city = self.city!
                destination.state = self.state!
                destination.zip = self.zip!
            }
        }
    }
    
}
