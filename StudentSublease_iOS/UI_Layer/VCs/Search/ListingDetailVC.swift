//
//  ListingDetailVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/30/21.
//

import UIKit

class ListingDetailVC: UIViewController {
    
    @IBOutlet var listingImageView: UIImageView!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var bedBathLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var startEndDateLabel: UILabel!
    @IBOutlet var messageListerButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var amenitiesLabel: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    var studentListing: StudentListingObject!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.studentListing.title
        self.messageListerButton.layer.cornerRadius = 6.0
        self.listingImageView.layer.cornerRadius = 8.0
        
        self.listingImageView.image = self.studentListing.images[0]
        self.addressLabel.text = self.studentListing.address
        self.bedBathLabel.text = String(studentListing.numBed) + " bed • " + String(self.studentListing.numBath) + " bath • " + String(self.studentListing.numTenants) + " spots available"
        self.costLabel.text = "$" + String(self.studentListing.rentPerMonth) + " • $" + String(self.studentListing.fees) + " in fees"
        self.startEndDateLabel.text = self.studentListing.startDate + " - " + self.studentListing.endDate
        self.descriptionLabel.text = self.studentListing.listingDescription
        let amenityText = (self.studentListing.amenities.map{String($0)}).joined(separator: ", ")
        self.amenitiesLabel.text = amenityText
    }
    
    @IBAction func messageUser(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startConversation", sender: self)
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.amenitiesLabel.frame.maxY + 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startConversation" {
            if let destination = segue.destination as? StartConversationVC {
                destination.listing = self.studentListing
            }
        }
    }

}
