//
//  CreateListingAddressVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingAddressVC: UIViewController {
    
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var stateTextField: UITextField!
    @IBOutlet var zipTextField: UITextField!
    @IBOutlet var nextButton: UIButton!

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
        self.performSegue(withIdentifier: "createProperty", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createProperty" {
            if let destination = segue.destination as? CreateListingPropertyVC {
                destination.street = self.streetTextField.text!
                destination.city = self.cityTextField.text!
                destination.state = self.stateTextField.text!
                destination.zip = self.zipTextField.text!
            }
        }
    }

}
