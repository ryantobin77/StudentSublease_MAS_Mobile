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
    var currentUser: SubleaseUserObject!
    var dimmingView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = self.studentListing.title
        self.currentUser = SubleaseUserObject.getUser(key: "currentUser")!
        self.messageListerButton.layer.cornerRadius = 6.0
        self.listingImageView.layer.cornerRadius = 8.0
        
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        if self.studentListing.images.count == 1 {
            self.listingImageView.image = self.studentListing.images[0]
        } else {
            self.listingImageView.animationImages = self.studentListing.images
            self.listingImageView.animationDuration = 3.0
            self.listingImageView.startAnimating()
        }
        self.addressLabel.text = self.studentListing.address
        self.bedBathLabel.text = String(studentListing.numBed) + " bed • " + String(self.studentListing.numBath) + " bath • " + String(self.studentListing.numTenants) + " spots available"
        self.costLabel.text = "$" + String(self.studentListing.rentPerMonth) + " • $" + String(self.studentListing.fees) + " in fees"
        self.startEndDateLabel.text = self.studentListing.startDate + " - " + self.studentListing.endDate
        self.descriptionLabel.text = self.studentListing.listingDescription
        let amenityText = (self.studentListing.amenities.map{String($0)}).joined(separator: ", ")
        self.amenitiesLabel.text = amenityText
        if self.currentUser.pk == self.studentListing.lister.pk {
            self.messageListerButton.setTitle("Delete Listing", for: .normal)
            self.messageListerButton.addTarget(self, action: #selector(deleteListingClicked(_:)), for: .touchUpInside)
        } else {
            self.messageListerButton.setTitle("Message Lister", for: .normal)
            self.messageListerButton.addTarget(self, action: #selector(messageUser(_:)), for: .touchUpInside)
        }
    }
    
    @objc func messageUser(_ sender: UIButton) {
        self.performSegue(withIdentifier: "startConversation", sender: self)
    }
    
    @objc func deleteListingClicked(_ sender: UIButton) {
        let alert = UIAlertController(title: "Delete Listing", message: "Are you sure you would like to delte this listing?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes, delete", style: .destructive, handler: {(action) in
            self.deleteListing()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteListing() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        StudentListingObject.delteListing(lister: self.currentUser, listing: self.studentListing, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong. Please try again.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }, success: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                let alert = UIAlertController(title: "Success", message: "Your sublease has been deleted!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {(action) in
                    DispatchQueue.main.async {
                        let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav2")
                        self.view.window?.rootViewController = navigationController
                        self.view.window?.makeKeyAndVisible()
                    }
                }))
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.amenitiesLabel.frame.maxY + 10)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "startConversation" {
            if let destination = segue.destination as? StartConversationVC {
                destination.listing = self.studentListing
                destination.tenant = self.currentUser
            }
        }
    }

}
