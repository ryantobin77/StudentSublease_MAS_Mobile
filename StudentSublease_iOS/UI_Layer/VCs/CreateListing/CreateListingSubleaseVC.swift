//
//  CreateListingSubleaseVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit
import CoreLocation

class CreateListingSubleaseVC: UIViewController {
    @IBOutlet weak var error: UILabel!
    @IBOutlet var startDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var rentTextField: UITextField!
    @IBOutlet var feesTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    
    var strPass: [String] = []
    var phto: [UIImage] = []
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
    var location: CLLocation?
    
    var numBed: Int?
    var numBath: Double?
    var numTenants: Int?
    var amenities: Array<String>?
    
    var startDate: String?
    var endDate: String?
    var rentPerMonth: Int?
    var fees: Int?
    
    var titleField: String?
    var descriptionField: String?
    
    var goingBack: Bool = true

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
        goingBack = false
        if rentTextField.text == "" ||  feesTextField.text == ""{
            error.text = "Please fill out all fields"
        } else if Int(rentTextField.text!) == nil || Int(rentTextField.text!)! <= 0 {
            error.text = "The rent must be a number greater than 0"
        } else if Int(feesTextField.text!) == nil || Int(feesTextField.text!)! < 0 {
            error.text = "The fees must be a number greater than or equal to 0"
        } else{
            self.performSegue(withIdentifier: "createFinal", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goingBack = true
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        if let start = self.startDate {
            startDatePicker.date = dateFormatter.date(from: start)!
        }
        if let end = self.endDate {
            endDatePicker.date = dateFormatter.date(from: end)!
        }
        if let rent = self.rentPerMonth {
            rentTextField.text = String(rent)
        }
        if let fee = self.fees {
            feesTextField.text = String(fee)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        guard let navC = navigationController else { return }
        if navC.viewControllers.firstIndex(of: self) != nil {
            return
        }
        guard let destination = navC.viewControllers.last as? CreateListingPropertyVC else {
            return
        }
        if goingBack {
            if let rent = self.rentTextField.text {
                self.rentPerMonth = Int(rent)
            }
            if let fee = self.feesTextField.text {
                self.fees = Int(fee)
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            destination.street = self.street
            destination.city = self.city
            destination.state = self.state
            destination.zip = self.zip
            destination.numBed = self.numBed
            destination.numBath = self.numBath
            destination.phto = self.phto
            destination.strPass = self.strPass
            destination.numTenants = self.numTenants
            destination.startDate = dateFormatter.string(from: self.startDatePicker.date)
            destination.endDate = dateFormatter.string(from: self.endDatePicker.date)
            destination.rentPerMonth = self.rentPerMonth
            destination.fees = self.fees
            destination.titleField = self.titleField
            destination.descriptionField = self.descriptionField
            destination.location = self.location
            destination.amenities = self.amenities
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createFinal" {
            if let destination = segue.destination as? CreateListingFinalVC {
                if let rent = self.rentTextField.text {
                    self.rentPerMonth = Int(rent)
                }
                if let fee = self.feesTextField.text {
                    self.fees = Int(fee)
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                destination.startDate = dateFormatter.string(from: self.startDatePicker.date)
                destination.endDate = dateFormatter.string(from: self.endDatePicker.date)
                destination.rentPerMonth = self.rentPerMonth
                destination.fees = self.fees
                destination.strPass = self.strPass
                destination.PhotoArray = self.phto
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.numTenants = self.numTenants
                destination.street = self.street
                destination.city = self.city
                destination.state = self.state
                destination.zip = self.zip
                destination.titleField = self.titleField
                destination.descriptionField = self.descriptionField
                destination.location = self.location
                destination.amenities = self.amenities
            }
        }
        
    }
    
}
