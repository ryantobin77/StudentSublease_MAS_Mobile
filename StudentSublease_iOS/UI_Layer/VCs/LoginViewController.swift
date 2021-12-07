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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    @IBAction func loginTapped(_ sender: Any) {
        var params = [String: Any]()
        params["email"] = emailTextField.text
        params["password"] = passwordTextField.text
    
        WebCallTasker().makePostRequest(forURL: BackendURL.LOGIN, withParams: params, failure: {}, success: {(data, response) in if (response.statusCode != 201) {DispatchQueue.main.async {
            self.errorLabel.alpha = 1
        }} else {self.transitionToHome()}})
        
    }
    
    
    func transitionToHome() {
        
        DispatchQueue.main.async {
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
            
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        }
    }
}
