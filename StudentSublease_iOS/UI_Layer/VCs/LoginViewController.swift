//
//  LoginViewController.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 12/2/21.
//

import UIKit

class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailTextField: UITextField!

    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        setUpElements()
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        var params = [String: Any]()
        params["email"] = emailTextField.text
        params["password"] = passwordTextField.text
        SubleaseUserObject.loginUser(email: emailTextField.text!, password: passwordTextField.text!, failure: {
            DispatchQueue.main.async {
                self.errorLabel.alpha = 1
            }
        }, success: {(user) in
            self.transitionToHome()
        })
    }
    
    
    func transitionToHome() {
        DispatchQueue.main.async {
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
