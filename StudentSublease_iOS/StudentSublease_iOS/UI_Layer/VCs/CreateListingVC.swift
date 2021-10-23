//
//  CreateListingVC.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 9/30/21.
//

import UIKit

class CreateListingVC: UIViewController {
    
    
    @IBOutlet var building: UIImageView!
    
    @IBOutlet var addpictures: UIButton!
    
    override func viewDidLoad() {
        self.building.layer.cornerRadius = 8.0;
        self.addpictures.layer.cornerRadius = 8.0;
    }
}
