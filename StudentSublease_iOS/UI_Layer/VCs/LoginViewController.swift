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
        Utilities.styleFilledButton(loginButton)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        var params = [String: Any]()
        params["email"] = emailTextField.text
        params["password"] = passwordTextField.text
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        SubleaseUserObject.loginUser(email: emailTextField.text!, password: passwordTextField.text!, failure: {
            DispatchQueue.main.async {
                self.errorLabel.alpha = 1
                loaderView.stopLoading()
            }
        }, success: {(user) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.transitionToHome()
            }
        })
    }
    
    
    func transitionToHome() {
        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
        self.view.window?.rootViewController = navigationController
        self.view.window?.makeKeyAndVisible()
    }
}
