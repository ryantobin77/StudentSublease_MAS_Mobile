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
        /*for amenity in self.studentListing.amenities {
            amenityText += "• " + amenity + "\n"
        }*/
        self.amenitiesLabel.text = amenityText
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
