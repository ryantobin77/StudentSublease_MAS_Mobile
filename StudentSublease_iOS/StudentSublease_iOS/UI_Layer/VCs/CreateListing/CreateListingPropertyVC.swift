//
//  CreateListingPropertyVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingPropertyVC: UIViewController {

    @IBOutlet weak var error: UILabel!
    @IBOutlet var numBedsTextField: UITextField!
    @IBOutlet var numBathsTextField: UITextField!
    @IBOutlet var numTenantsTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
    
    var strPass: [String] = []
    var phto: [UIImage] = []
    
    var street: String?
    var city: String?
    var state: String?
    var zip: String?
    
   
    var numBed: Int?
    var numBath: Double?
    var numTenants: Int?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        goingBack = true
        if let bed = self.numBed {
            self.numBedsTextField.text = String(bed)
        }
        if let bath = self.numBath {
            self.numBathsTextField.text = String(Int(bath))
        }
        if let tenants = self.numTenants {
            self.numTenantsTextField.text = String(tenants)
        }
    }
   
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        goingBack = false
        if numBedsTextField.text == "" ||  numBathsTextField.text == "" || numTenantsTextField.text == ""{
            error.text = "Please fill out all fields"
        } else if Int(numBedsTextField.text!) == nil || Int(numBedsTextField.text!)! <= 0 {
            error.text = "The number of beds must be a number greater than 0"
        } else if Int(numBathsTextField.text!) == nil || Int(numBathsTextField.text!)! <= 0 {
            error.text = "The number of baths must be a number greater than 0"
        } else if Int(numTenantsTextField.text!) == nil || Int(numTenantsTextField.text!)! <= 0 {
            error.text = "The number of tenants must be a number greater than 0"
        } else if (numTenantsTextField.text?.contains("."))! {
            error.text = "Please enter an appropriate number of tenants"
        } else{
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
   
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if goingBack {
            self.numBed = Int(self.numBedsTextField.text!)
            self.numBath = Double(self.numBathsTextField.text!)
            self.numTenants = Int(self.numTenantsTextField.text!)
            guard let navC = navigationController else { return }
            if navC.viewControllers.firstIndex(of: self) != nil {
                return
            }
            guard let destination = navC.viewControllers.last as? CreateListingAddressVC else {
                return
            }
            destination.street = self.street
            destination.city = self.city
            destination.state = self.state
            destination.zip = self.zip
            destination.numBed = self.numBed
            destination.strPass = self.strPass
            destination.phto = self.phto
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSublease" {
            if let destination = segue.destination as? CreateListingSubleaseVC {
                self.numBed = Int(self.numBedsTextField.text!)
                self.numBath = Double(self.numBathsTextField.text!)
                self.numTenants = Int(self.numTenantsTextField.text!)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd"
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.phto = self.phto
                destination.strPass = self.strPass
                destination.numTenants = self.numTenants
                destination.street = self.street
                destination.city = self.city
                destination.state = self.state
                destination.zip = self.zip
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
