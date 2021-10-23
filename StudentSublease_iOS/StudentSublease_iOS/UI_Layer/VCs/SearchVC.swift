//
//  ViewController.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/29/21.
//

import UIKit

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var searchResultsTableView: UITableView!
    let searchCellID = "searchCell"
    var menuButtonVisible = false
    var searchResults: Array<StudentListingObject>!
    var dimmingView: UIView!
    var selectedStudentListing: StudentListingObject?
    
    @IBAction func menuButtonTapped(_ sender: Any) {
        if (!menuButtonVisible) {
            self.leadingConstraint.constant = 150
            self.trailingConstraint.constant = 150
            self.dimmingView.alpha = 0.6
            self.menuButtonVisible = true
        } else {
            self.leadingConstraint.constant = 0
            self.trailingConstraint.constant = 0
            self.dimmingView.alpha = 0.0
            self.menuButtonVisible = false
        }
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.view.layoutIfNeeded()
        }) { (animationComplete) in
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentListing = self.searchResults[indexPath.row]
        let cell: SearchCell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: searchCellID) as! SearchCell
        cell.listingImageView.image = studentListing.images[0]
        cell.listingImageView.layer.cornerRadius = 8.0
        cell.titleLabel.text = studentListing.title
        cell.bedBathLabel.text = String(studentListing.numBed) + " bed • " + String(studentListing.numBath) + " bath"
        cell.distanceLabel.text = "0.5 mi away • " + String(studentListing.numTenants) + " spots available"
        cell.startEndDateLabel.text = studentListing.startDate + " - " + studentListing.endDate
        cell.rentLabel.text = "$" + String(studentListing.rentPerMonth) + " / month"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedStudentListing = self.searchResults[indexPath.row]
        self.performSegue(withIdentifier: "viewListing", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewListing" {
            if let destination = segue.destination as? ListingDetailVC, let selectedListing = self.selectedStudentListing {
                destination.studentListing = selectedListing
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = StudentListingObject.getStudentListings()
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.estimatedRowHeight = 335
        self.searchResultsTableView.rowHeight = 335
        
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.mainView.addSubview(self.dimmingView)
    }


}

