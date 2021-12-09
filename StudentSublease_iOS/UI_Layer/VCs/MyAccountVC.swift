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

        self.currentUser = SubleaseUserObject.getUser(key: "currentUser")!
        self.nameLabel.text = currentUser.firstName + " " + self.currentUser.lastName
        self.collegeLabel.text = currentUser.college
        self.emailLabel.text = currentUser.email
        
        self.logoutButton.layer.cornerRadius = 6.0
    }
    
    @IBAction func logoutPressed(_ sender: UIButton) {
        self.currentUser.logout(failure: {
            let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }, success: {
            DispatchQueue.main.async {
                let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav1")
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        })
    }

}
