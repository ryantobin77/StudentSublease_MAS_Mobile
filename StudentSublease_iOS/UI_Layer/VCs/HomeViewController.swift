//
//  HomeViewController.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 12/2/21.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var signupButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setUpElements()
    }
    

    @IBOutlet weak var loginimage: UIImageView!
    
    
    func setUpElements() {
        Utilities.styleFilledButton(signupButton)
        Utilities.styleHollowButton(loginButton)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    override func viewWillAppear(_ animated: Bool) {
        loginimage?.frame = CGRect(x: -self.view.frame.size.width * 0.3, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height * 1.5)
        
         super.viewWillAppear(animated)
        self.navigationController!.isNavigationBarHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
        self.navigationController!.isNavigationBarHidden = false

    }
    
    

}
