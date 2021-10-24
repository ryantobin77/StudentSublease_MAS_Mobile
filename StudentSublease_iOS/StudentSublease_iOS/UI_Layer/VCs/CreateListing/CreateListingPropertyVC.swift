//
//  CreateListingPropertyVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class CreateListingPropertyVC: UIViewController {
    
    @IBOutlet var numBedsTextField: UITextField!
    @IBOutlet var numBathsTextField: UITextField!
    @IBOutlet var numTenantsTextField: UITextField!
    @IBOutlet var nextButton: UIButton!
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
        self.performSegue(withIdentifier: "createSublease", sender: self)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSublease" {
            if let destination = segue.destination as? CreateListingSubleaseVC {
                destination.numBed = Int(self.numBedsTextField.text!)
                destination.numBath = Double(self.numBathsTextField.text!)
                destination.numTenants = Int(self.numTenantsTextField.text!)
                destination.street = self.street!
                destination.city = self.city!
                destination.state = self.state!
                destination.zip = self.zip!
            }
        }
    }

}
