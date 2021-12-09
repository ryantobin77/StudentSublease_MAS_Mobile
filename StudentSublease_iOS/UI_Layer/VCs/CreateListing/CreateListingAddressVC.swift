//
//  CreateListingAddressVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit
import CoreLocation

class CreateListingAddressVC: UIViewController {
    @IBOutlet weak var error: UILabel!
    
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipTextField: UITextField!
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nextButton.layer.cornerRadius = 8.0
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        self.streetTextField.text = self.street ?? ""
        self.cityTextField.text = self.city ?? ""
        self.stateTextField.text = self.state ?? ""
        self.zipTextField.text = self.zip ?? ""
        
    }
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if streetTextField.text == "" ||  cityTextField.text == "" || stateTextField.text == "" || zipTextField.text == "" {
            error.text = "Please fill out all fields"
        } else if zipTextField.text!.count != 5 || Int(self.zipTextField.text!) == nil {
            error.text = "Zip code must be 5 digits long"
        } else if !isValidState(stateTextField.text!.uppercased()) {
            error.text = "You must enter a valid state abbreviation"
        } else {
            self.street = self.streetTextField.text!
            self.city = self.cityTextField.text!
            self.state = self.stateTextField.text!
            self.zip = self.zipTextField.text!
            self.getAddressLocation(failure: {
                self.error.text = "You entered an invalid location"
            }, success: {(location) in
                self.location = location
                self.performSegue(withIdentifier: "createProperty", sender: self)
            })
        }
    }
    
    func isValidState(_ state: String) -> Bool {
        let stateRegex = "^((A[LKZR])|(C[AOT])|(D[EC])|(FL)|(GA)|(HI)|(I[DLNA])|(K[SY])|(LA)|(M[EDAINSOT])|(N[EVHJMYCD])|(O[HKR])|(PA)|(RI)|(S[CD])|(T[NX])|(UT)|(V[TA])|(W[AVIY]))$"
        let statePred = NSPredicate(format:"SELF MATCHES %@", stateRegex)
        return statePred.evaluate(with: state)
    }
    
    func getAddressLocation(failure: @escaping () -> Void, success: @escaping (_ location: CLLocation) -> Void) {
        let address = self.streetTextField.text! + ", " + self.cityTextField.text! + ", " + self.stateTextField.text! + " " + self.zipTextField.text!
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let location = placemarks.first?.location else {
                failure()
                return
            }
            success(location)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createProperty" {
            if let destination = segue.destination as? CreateListingPropertyVC {
                destination.street = self.street
                destination.city = self.city
                destination.state = self.state
                destination.zip = self.zip
                destination.phto = self.phto
                destination.strPass = self.strPass
                destination.numBed = self.numBed
                destination.numBath = self.numBath
                destination.numTenants = self.numTenants
                destination.startDate = self.startDate
                destination.endDate = self.endDate
                destination.rentPerMonth = self.rentPerMonth
                destination.fees = self.fees
                destination.titleField = self.titleField
                destination.descriptionField = self.descriptionField
                destination.location = self.location
                destination.amenities = self.amenities
            }
        }
    }

}
