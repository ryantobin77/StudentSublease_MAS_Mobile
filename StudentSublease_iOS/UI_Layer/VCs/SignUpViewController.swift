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
    var dimmingView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        setUpElements()
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
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
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        WebCallTasker().makePostRequest(forURL: BackendURL.SIGN_UP, withParams: params, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.errorLabel.alpha = 1
            }
        }, success: {(data, response) in
            if (response.statusCode != 201) {
                DispatchQueue.main.async {
                    loaderView.stopLoading()
                    self.errorLabel.alpha = 1
                }
            } else {
                DispatchQueue.main.async {
                    let user = SubleaseUserObject.parseJson(jsonData: data)!
                    if user.saveUser(key: "currentUser") {
                        loaderView.stopLoading()
                        transitionToHome()
                    } else {
                        loaderView.stopLoading()
                        self.errorLabel.alpha = 1
                    }
                }
            }
        })
      
        
        func transitionToHome() {
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
            
        }
        
    }
    

}
