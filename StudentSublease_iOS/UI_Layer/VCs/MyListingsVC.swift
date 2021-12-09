//
//  MyListingsVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/9/21.
//

import UIKit

class MyListingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentUser: SubleaseUserObject!
    var myListingResults: Array<StudentListingObject>!
    var dimmingView: UIView!
    var selectedStudentListing: StudentListingObject?
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUser = SubleaseUserObject.getUser(key: "currentUser")!
        self.myListingResults = Array<StudentListingObject>()
        
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 335
        self.tableView.rowHeight = 335
        self.getMyListings()
    }
    
    func getMyListings() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        StudentListingObject.getMyListings(lister: self.currentUser, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.myListingResults = Array<StudentListingObject>()
                self.tableView.reloadData()
            }
        }, success: {(listings) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.myListingResults = listings
                self.tableView.reloadData()
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.myListingResults.count == 0 {
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            let emptyLabel = UILabel(frame: frame)
            emptyLabel.textAlignment = .center
            
            let icon = UIImage(systemName: "building.2.fill")
            let iconAttachment = NSTextAttachment(image: icon!)
            let mutableIconString = NSMutableAttributedString(attachment: iconAttachment)
            mutableIconString.append(NSAttributedString(string: " You have no listings!"))
            emptyLabel.attributedText = mutableIconString
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
            return 0
        }
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        return self.myListingResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentListing = self.myListingResults[indexPath.row]
        let cell: SearchCell = self.tableView.dequeueReusableCell(withIdentifier: "myListingCell") as! SearchCell
        cell.listingImageView.image = studentListing.images[0]
        cell.listingImageView.layer.cornerRadius = 8.0
        cell.titleLabel.text = studentListing.title
        cell.bedBathLabel.text = String(studentListing.numBed) + " bed • " + String(studentListing.numBath) + " bath"
        cell.distanceLabel.text = String(studentListing.distance) + " mi away • " + String(studentListing.numTenants) + " spots available"
        cell.startEndDateLabel.text = studentListing.startDate + " - " + studentListing.endDate
        cell.rentLabel.text = "$" + String(studentListing.rentPerMonth) + " / month"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedStudentListing = self.myListingResults[indexPath.row]
        self.performSegue(withIdentifier: "viewMyListing", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewMyListing" {
            if let destination = segue.destination as? ListingDetailVC, let selectedListing = self.selectedStudentListing {
                destination.studentListing = selectedListing
            }
        }
    }
    
}
