//
//  SearchResultsVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 11/5/21.
//

import UIKit
import MapKit

class SearchResultsVC: UITableViewController, UISearchResultsUpdating {
    
    var matchingItems:[MKMapItem] = []
    var currentLocation: CLLocation!
    var handleLocationSearchDelegate: HandleLocationSearch? = nil
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.matchingItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell")!
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = "\(selectedItem.name ?? "") - \(self.getDistanceFromCurrent(location: selectedItem.location!)) mi"
        cell.detailTextLabel?.text = self.parseAddress(selectedItem: selectedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = matchingItems[indexPath.row]
        handleLocationSearchDelegate?.searchedLocation(location: selectedItem)
        dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let distance = CLLocationDistance(25000)
        let region = MKCoordinateRegion(center: currentLocation.coordinate, latitudinalMeters: distance, longitudinalMeters: distance)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchBarText
        request.region = region
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
            self.tableView.reloadData()
        }
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    func getDistanceFromCurrent(location: CLLocation) -> Double {
        let distance = currentLocation.distance(from: location) * 0.000621371
        let divisor = pow(10.0, 2.0)
        let result = round(Double(distance) * divisor) / divisor
        return result
    }
    
}
