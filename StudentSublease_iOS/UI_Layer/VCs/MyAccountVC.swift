//
//  MyAccountVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/5/21.
//

import UIKit

class MyAccountVC: UIViewController {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var collegeLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var logoutButton: UIButton!
    var currentUser: SubleaseUserObject!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.currentUser = SubleaseUserObject(pk: 2, email: "ryantobin77@gatech.edu", firstName: "Ryan", lastName: "Tobin", college: "Georgia Institute of Technology")
        self.nameLabel.text = currentUser.firstName + " " + self.currentUser.lastName
        self.collegeLabel.text = currentUser.college
        self.emailLabel.text = currentUser.email
        
        self.logoutButton.layer.cornerRadius = 6.0
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        print("Logout pressed")
    }

}
