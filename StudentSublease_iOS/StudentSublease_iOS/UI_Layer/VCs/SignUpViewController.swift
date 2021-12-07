//
//  SignUpViewController.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 12/2/21.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstnameTextField: UITextField!
    @IBOutlet weak var lastnameTextField: UITextField!
    @IBOutlet weak var collegeTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(firstnameTextField)
        Utilities.styleTextField(lastnameTextField)
        Utilities.styleTextField(collegeTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signupButton)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func signupTapped(_ sender: Any) {
        var params = [String: Any]()
        params["email"] = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        params["first_name"] = firstnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        params["last_name"] = lastnameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        params["college"] = collegeTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        params["password"] = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
    
        WebCallTasker().makePostRequest(forURL: BackendURL.SIGN_UP, withParams: params, failure: {DispatchQueue.main.async {
            self.errorLabel.alpha = 1
        }}, success: {(data, response) in if (response.statusCode != 201){DispatchQueue.main.async {
            self.errorLabel.alpha = 1
        }} else {transitionToHome()}})
      
        
        func transitionToHome() {
            
            DispatchQueue.main.async {
                let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
                
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    

}
