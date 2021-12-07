//
//  ViewController.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/29/21.
//

import UIKit
import DropDown

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
    var transparentView = UIView()
    let height: CGFloat = 620
    @IBOutlet var filtermenu: UIView!
    
    @IBOutlet var tableView2: UIView!
    
    @IBOutlet weak var startmonthview: UIView!
    @IBOutlet weak var startmonthlabel: UILabel!
    
    @IBOutlet weak var endmonthview: UIView!
    @IBOutlet weak var endmonthlabel: UILabel!
    
    @IBOutlet weak var genderpreferencesview: UIView!
    @IBOutlet weak var genderpreferenceslabel: UILabel!
    
    
    
    
    let dropDown1 = DropDown()
    let dropDownValues = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
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
    
    func getSearchResults() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        StudentListingObject.searchListings(failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.searchResults = Array<StudentListingObject>()
                self.searchResultsTableView.reloadData()
            }
        }, success: {(listingsData) in
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.searchResults = listingsData
                self.searchResultsTableView.reloadData()
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.searchResults = Array<StudentListingObject>()
        self.getSearchResults()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchResults = Array<StudentListingObject>()
        
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
            self.startmonthlabel.text = dropDown1.dataSource[index]
        }
        
        dropDown2.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.endmonthlabel.text = dropDown2.dataSource[index]
        }
        
        dropDown3.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            self.genderpreferenceslabel.text = dropDown3.dataSource[index]
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
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView))
        
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0.5
            self.filtermenu.frame = CGRect(x: 0, y: screenSize.height - self.height, width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0
            self.filtermenu.frame = CGRect(x: 0, y: screenSize.height , width: screenSize.width, height: self.height)
        }, completion: nil)
    }
    
    let height2: CGFloat = 250
    
    @IBAction func sort(_ sender: UIButton) {
        self.tableView2.backgroundColor = UIColor.white
        let window = UIApplication.shared.keyWindow
        transparentView.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        transparentView.frame = self.view.frame
        window?.addSubview(transparentView)

        let screenSize = UIScreen.main.bounds.size
        tableView2.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height2)
        
        window?.addSubview(tableView2)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(onClickTransparentView2))
        
        transparentView.addGestureRecognizer(tapGesture)
        
        transparentView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0.5
            self.tableView2.frame = CGRect(x: 0, y: screenSize.height - self.height2, width: screenSize.width, height: self.height2)
        }, completion: nil)
    }
    
    @objc func onClickTransparentView2(){
        let screenSize = UIScreen.main.bounds.size
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {self.transparentView.alpha = 0
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
    
    
    @IBOutlet weak var minBed: UITextField!
    @IBOutlet weak var maxBed: UITextField!
    
    @IBOutlet weak var minBath: UITextField!
    @IBOutlet weak var maxBath: UITextField!
    
    
    @IBOutlet weak var minRent: UITextField!
    @IBOutlet weak var maxRent: UITextField!
    
    
    @IBAction func applyFilters(_ sender: UIButton) {
        let minbed = minBed.text!
        var realminbed = Int(minbed) ?? 0
        let maxbed = maxBed.text!
        var realmaxbed = Int(maxbed) ?? 100
        let minbath = minBath.text!
        var realminbath = Double(minbath) ?? 0.0
        let maxbath = maxBath.text!
        var realmaxbath = Double(maxbath) ?? 100.0
        let minrent = minRent.text!
        var realminrent = Int(minrent) ?? 0
        let maxrent = maxRent.text!
        var realmaxrent = Int(maxrent) ?? 10000
        var startmonth = startmonthlabel.text
        var endmonth = endmonthlabel.text
        var genderpreference = genderpreferenceslabel.text
        
        
        let filteredList = searchResults.filter{$0.numBed > realminbed && $0.numBed < realmaxbed && $0.numBath > realminbath && $0.numBath < realmaxbath && $0.rentPerMonth > realminrent && $0.rentPerMonth < realmaxrent}
                
        
        let totalList = searchResults
        
        searchResults = filteredList
        
        searchResultsTableView.reloadData()
    }
    
    
    @IBAction func sortByDistance(_ sender: Any) {
        print("we will figure this out later")
    }
    
    
    @IBAction func sortByPriceLow(_ sender: Any) {
        searchResults.sort {
            $0.rentPerMonth < $1.rentPerMonth
        }
        searchResultsTableView.reloadData()
    }
    
    
    @IBAction func sortByPriceHigh(_ sender: Any) {
        searchResults.sort {
            $0.rentPerMonth > $1.rentPerMonth
        }
        searchResultsTableView.reloadData()
    }
    
    @IBAction func logout(_ sender: Any) {
        var params = [String: Any]()
        WebCallTasker().makePostRequest(forURL: BackendURL.LOGOUT, withParams: params, failure: {}, success: {(data, response) in if (response.statusCode == 201){DispatchQueue.main.async {
            let navigationController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Nav1")
            
            self.view.window?.rootViewController = navigationController
            self.view.window?.makeKeyAndVisible()
        }}})
    }
    
    @IBAction func sortByStartDate(_ sender: Any) {
        
    }
    
    
    @IBAction func sortByMostRecent(_ sender: Any) {
        
    }
}




