//
//  ViewController.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/29/21.
//

import UIKit
import MapKit
import DropDown

protocol HandleLocationSearch {
    func searchedLocation(location: MKMapItem)
}

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate, HandleLocationSearch {
    
    @IBOutlet var mainView: UIView!
    @IBOutlet var leadingConstraint: NSLayoutConstraint!
    @IBOutlet var trailingConstraint: NSLayoutConstraint!
    @IBOutlet var searchResultsTableView: UITableView!
    let searchCellID = "searchCell"
    var menuButtonVisible = false
    
    var searchResults: Array<StudentListingObject>!
    var unfilteredResults: Array<StudentListingObject>!
    
    var dimmingView: UIView!
    var selectedStudentListing: StudentListingObject?
    
    let locationManager = CLLocationManager()
    var resultSearchController: UISearchController? = nil
    var locationSearchTable: SearchResultsVC!

    var transparentView = UIView()
    let height: CGFloat = 620
    @IBOutlet var filtermenu: UIView!
    @IBOutlet var applyFilterButton: UIButton!
    
    @IBOutlet var tableView2: UIView!
    
    @IBOutlet weak var startmonthview: UIView!
    @IBOutlet weak var startmonthlabel: UILabel!
    
    @IBOutlet weak var endmonthview: UIView!
    @IBOutlet weak var endmonthlabel: UILabel!
    
    @IBOutlet weak var genderpreferencesview: UIView!
    @IBOutlet weak var genderpreferenceslabel: UILabel!
    
    @IBOutlet weak var minBed: UITextField!
    @IBOutlet weak var maxBed: UITextField!
    
    @IBOutlet weak var minBath: UITextField!
    @IBOutlet weak var maxBath: UITextField!
    
    
    @IBOutlet weak var minRent: UITextField!
    @IBOutlet weak var maxRent: UITextField!
    
    var searchBar: UISearchBar!
    
    let height2: CGFloat = 250
    
    let dropDown1 = DropDown()
    let dropDownValues = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    let monthDict = [
        "Start Month" : 0,
        "End Month" : 13,
        "January" : 1,
        "February" : 2,
        "March" : 3,
        "April" : 4,
        "May" : 5,
        "June" : 6,
        "July" : 7,
        "August" : 8,
        "September" : 9,
        "October" : 10,
        "November" : 11,
        "December" : 12
    ]
    
    let dropDown2 = DropDown()
    
    let dropDown3 = DropDown()
    let dropDownValuesGender = ["Male", "Female", "No Preference"]
    
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
    
    func getSearchResults(location: CLLocation?) {
        var lat: Float?
        var long: Float?
        if let searchedLocation = location {
            lat = Float(searchedLocation.coordinate.latitude)
            long = Float(searchedLocation.coordinate.longitude)
        }
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        StudentListingObject.searchListings(lat: lat, long: long, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.searchResults = Array<StudentListingObject>()
                self.unfilteredResults = self.searchResults
                self.searchResultsTableView.reloadData()
            }
        }, success: {(listingsData) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.searchResults = listingsData
                self.unfilteredResults = self.searchResults
                self.searchResultsTableView.reloadData()
            }
        })
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.searchResults.count == 0 {
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            let emptyLabel = UILabel(frame: frame)
            emptyLabel.textAlignment = .center
            
            let icon = UIImage(systemName: "magnifyingglass")
            let iconAttachment = NSTextAttachment(image: icon!)
            let mutableIconString = NSMutableAttributedString(attachment: iconAttachment)
            mutableIconString.append(NSAttributedString(string: " No Search Results!"))
            emptyLabel.attributedText = mutableIconString
            
            self.searchResultsTableView.backgroundView = emptyLabel
            self.searchResultsTableView.separatorStyle = .none
            return 0
        }
        self.searchResultsTableView.backgroundView = nil
        self.searchResultsTableView.separatorStyle = .singleLine
        return self.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let studentListing = self.searchResults[indexPath.row]
        let cell: SearchCell = self.searchResultsTableView.dequeueReusableCell(withIdentifier: searchCellID) as! SearchCell
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
        self.selectedStudentListing = self.searchResults[indexPath.row]
        self.performSegue(withIdentifier: "viewListing", sender: self)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.locationSearchTable.currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error: \(error)")
    }
    
    func searchedLocation(location: MKMapItem) {
        if let searchedName = location.name {
            self.searchBar.text = searchedName
        }
        self.getSearchResults(location: location.placemark.location)
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
        self.searchResults = Array<StudentListingObject>()
        self.unfilteredResults = self.searchResults
        
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.searchResultsTableView.delegate = self
        self.searchResultsTableView.dataSource = self
        self.searchResultsTableView.estimatedRowHeight = 335
        self.searchResultsTableView.rowHeight = 335
        
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.mainView.addSubview(self.dimmingView)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "SearchResults") as? SearchResultsVC
        locationSearchTable.handleLocationSearchDelegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        self.searchBar = resultSearchController!.searchBar
        self.searchBar.sizeToFit()
        self.searchBar.placeholder = "Search a location..."
        navigationItem.titleView = resultSearchController?.searchBar
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        self.applyFilterButton.layer.cornerRadius = 8.0
        
        dropDown1.anchorView = startmonthview
        dropDown1.dataSource = dropDownValues
        dropDown1.direction = .bottom
        startmonthview.layer.cornerRadius = 20
        
        dropDown2.anchorView = endmonthview
        dropDown2.dataSource = dropDownValues
        dropDown2.direction = .bottom
        endmonthview.layer.cornerRadius = 20
        
        
        dropDown3.anchorView = genderpreferencesview
        dropDown3.dataSource = dropDownValuesGender
        dropDown3.direction = .bottom
        genderpreferencesview.layer.cornerRadius = 20
        
        dropDown1.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.startmonthlabel.text = self.dropDown1.dataSource[index]
        }
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.endmonthlabel.text = self.dropDown2.dataSource[index]
        }
        
        dropDown3.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.genderpreferenceslabel.text = self.dropDown3.dataSource[index]
        }

    }
    
    @IBAction func filter(_ sender: UIButton) {
        self.filtermenu.backgroundColor = UIColor.white
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)

        let screenSize = UIScreen.main.bounds.size
        filtermenu.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        
        window?.addSubview(filtermenu)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeFilterMenu))
        
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0.5
            self.filtermenu.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func closeFilterMenu(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0
            self.filtermenu.frame = CGRect(x: 0, y: screenSize.height , width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @IBAction func sort(_ sender: UIButton) {
        self.tableView2.backgroundColor = UIColor.white
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)

        let screenSize = UIScreen.main.bounds.size
        tableView2.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height2)
        
        window?.addSubview(tableView2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(closeSortMenu))
        
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0.5
            self.tableView2.frame = CGRect(x: 0, y: screenSize.height - self.height2, width: screenSize.width, height: self.height2)
        }, completion: nil)
    }
    
    @objc func closeSortMenu(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0
            self.tableView2.frame = CGRect(x: 0, y: screenSize.height , width: screenSize.width, height: self.height2)
        }, completion: nil)
    }
    
    
    
    @IBAction func startmonthbutton(_ sender: Any) {
        dropDown1.show()
    }
    
    @IBAction func endmonthbutton(_ sender: Any) {
        dropDown2.show()
    }
    
    @IBAction func genderpreferencesbutton(_ sender: Any) {
        dropDown3.show()
    }
    
    @IBAction func amenityButtonPressed(_ sender: Any) {
        let unselectedImage = UIImage(systemName: "circle")
        let selectedImage = UIImage(systemName: "circle.fill")
        if (sender as AnyObject).currentBackgroundImage == unselectedImage {
            (sender as AnyObject).setBackgroundImage(selectedImage, for: .normal)
        } else {
            (sender as AnyObject).setBackgroundImage(unselectedImage, for: .normal)
        }
    }
    
    @IBAction func applyFilters(_ sender: UIButton) {
        let minbed = minBed.text!
        let realminbed = Int(minbed) ?? 0
        let maxbed = maxBed.text!
        let realmaxbed = Int(maxbed) ?? 100
        let minbath = minBath.text!
        let realminbath = Double(minbath) ?? 0.0
        let maxbath = maxBath.text!
        let realmaxbath = Double(maxbath) ?? 100.0
        let minrent = minRent.text!
        let realminrent = Int(minrent) ?? 0
        let maxrent = maxRent.text!
        let realmaxrent = Int(maxrent) ?? 10000
        let filterStartMonth = monthDict[startmonthlabel.text ?? "Start Month"]
        let filterEndMonth = monthDict[endmonthlabel.text ?? "End Month"]
        // let genderpreference = genderpreferenceslabel.text
        
        
        let initialFilters = self.unfilteredResults.filter{
            $0.numBed >= realminbed
            && $0.numBed <= realmaxbed
            && $0.numBath >= realminbath
            && $0.numBath <= realmaxbath
            && $0.rentPerMonth >= realminrent
            && $0.rentPerMonth <= realmaxrent
        }
        
        var filteredList: Array<StudentListingObject> = Array<StudentListingObject>()
        for result in initialFilters {
            let startDateIndex = result.startDate.index(result.startDate.startIndex, offsetBy: 2)
            let startDateMonth = Int(result.startDate.prefix(upTo: startDateIndex))
            
            let endDateIndex = result.endDate.index(result.endDate.startIndex, offsetBy: 2)
            let endDateMonth = Int(result.endDate.prefix(upTo: endDateIndex))
            
            if (filterStartMonth == 0 || filterStartMonth == startDateMonth) && (filterEndMonth == 13 || filterEndMonth == endDateMonth ) {
                filteredList.append(result)
            }
            
        }
        
        self.searchResults = filteredList
        self.searchResultsTableView.reloadData()
        self.closeFilterMenu()
    }
    
    
    @IBAction func sortByDistance(_ sender: Any) {
        searchResults.sort {
            $0.distance < $1.distance
        }
        searchResultsTableView.reloadData()
        self.closeSortMenu()
    }
    
    
    @IBAction func sortByPriceLow(_ sender: Any) {
        searchResults.sort {
            $0.rentPerMonth < $1.rentPerMonth
        }
        searchResultsTableView.reloadData()
        self.closeSortMenu()
    }
    
    
    @IBAction func sortByPriceHigh(_ sender: Any) {
        searchResults.sort {
            $0.rentPerMonth > $1.rentPerMonth
        }
        searchResultsTableView.reloadData()
        self.closeSortMenu()
    }
    
    
    @IBAction func sortByStartDate(_ sender: Any) {
        searchResults.sort {
            $0.getStartDate() < $1.getStartDate()
        }
        searchResultsTableView.reloadData()
        self.closeSortMenu()
    }
    
    
    @IBAction func sortByMostRecent(_ sender: Any) {
        searchResults.sort {
            $0.getListedDate() < $1.getListedDate()
        }
        searchResultsTableView.reloadData()
        self.closeSortMenu()
    }
}




