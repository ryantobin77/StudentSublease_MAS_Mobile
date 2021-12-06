//
//  StudentListingObject.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/30/21.
//

import UIKit

class StudentListingObject: NSObject {


    var pk: Int!
    var title: String!
    var address: String!
    var lister: String!
    var listedDate: String!
    var listingDescription: String!
    var numBed: Int!
    var numBath: Double!
    var amenities: Array<String>!
    var genderPreference: Int!
    var startDate: String!
    var endDate: String!
    var rentPerMonth: Int!
    var numTenants: Int!
    var fees: Int!
    var images: Array<UIImage>!
    

    
    init(pk: Int, title: String, address: String, lister: String, listedDate: String, listingDescription: String, numBed: Int, numBath: Double, amenities: Array<String>, genderPreference: Int, startDate: String, endDate: String, rentPerMonth: Int, numTenants: Int, fees: Int) {
        self.title = title
        self.address = address
        self.lister = lister
        self.listedDate = listedDate
        self.listingDescription = listingDescription
        self.numBed = numBed
        self.numBath = numBath
        self.amenities = amenities
        self.genderPreference = genderPreference
        self.startDate = startDate
        self.endDate = endDate
        self.rentPerMonth = rentPerMonth
        self.numTenants = numTenants
        self.fees = fees
        //self.images = images
    }
    
    
    class func createListing(title: String, street: String, city: String, state: String, zip: String, listingDescription: String, numBed: Int, numBath: Double, startDate: String, endDate: String, rentPerMonth: Int, fees: Int, numTenants: Int, images: Array<UIImage>, failure: @escaping () -> Void, success: @escaping (_ listing: StudentListingObject?) -> Void) {
        let webCallTakser: WebCallTasker = WebCallTasker()
        var params = [String: Any]()
        params["title"] = title
        params["street"] = street
        params["city"] = city
        params["state"] = state
        params["zip"] = zip
        params["lat"] = 33.777180 // Fix hardcode
        params["long"] = -84.392350 // Fix hardcode
        params["lister_pk"] = 1 // Fix hardcode
        params["description"] = listingDescription
        params["num_bed"] = numBed
        params["num_bath"] = numBath
        params["gender_preference"] = 0 // Fix hardcode
        params["start_date"] = startDate
        params["end_date"] = endDate
        params["rent_per_month"] = rentPerMonth
        params["fees"] = fees
        params["num_tenants"] = numTenants
        params["images"] = images
        
    
        
        webCallTakser.makePostRequestImage(image: images, forURL: BackendURL.CREATE_LISTING_PATH, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 201 {
                failure()
                return
            }
            print("DATA: " , data)
            print("Response: " , response)
            let listing = StudentListingObject.parseJson(jsonData: data)
            print("my Listing: " , listing)
            success(listing)
            })
    }
    
    class func searchListings(failure: @escaping () -> Void, success: @escaping (_ listings: Array<StudentListingObject>?) -> Void) {
        StudentListingObject.searchListings(lat: nil, long: nil, failure: failure, success: success)
    }
    
    class func searchListings(lat: Float?, long: Float?, failure: @escaping () -> Void, success: @escaping (_ listings: Array<StudentListingObject>?) -> Void) {
        var params: [String: Any] = [String: Any]()
        if let latVal = lat, let longVal = long {
            params["lat"] = latVal
            params["long"] = longVal
        }
        let webCallTasker: WebCallTasker = WebCallTasker()
        webCallTasker.makeGetRequest(forBaseURL: BackendURL.SEARCH_LISTINGS_PATH, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            guard let listings = try? JSONSerialization.jsonObject(with: data) as? Array<[String: Any]> else {
                failure()
                return
            }
            var result: Array<StudentListingObject> = Array<StudentListingObject>()
            for listing in listings {
                guard let listingData = try? JSONSerialization.data(withJSONObject: listing, options: []) else {
                    continue
                }
                if let parsedListing = StudentListingObject.parseJson(jsonData: listingData) {
                    result.append(parsedListing)
                }
            }
            success(result)
        })
    }
    
    class func parseJson(jsonData: Data) -> StudentListingObject? {
        guard let listing_json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            print("heree:e")
            return nil
        }
        print("listing:: : : : : " , listing_json)
        let pk = listing_json["pk"] as! Int
        let title = listing_json["title"] as! String
        let address = listing_json["address"] as! String
        let lister = "Ryan Tobin"
        let listedDate = listing_json["listed_date"] as! String
        let description = listing_json["description"] as! String
        let numBed = listing_json["num_bed"] as! Int
        let numBath = listing_json["num_bath"] as! Double
        let amenities = listing_json["amenities"] as! Array<String>
        let genderPreference = listing_json["gender_preference"] as! Int
        let startDate = listing_json["start_date"] as! String
        let endDate = listing_json["end_date"] as! String
        let rentPerMonth = listing_json["rent_per_month"] as! Int
        let numTenants = listing_json["num_tenants"] as! Int
        let fees = listing_json["fees"] as! Int
        return StudentListingObject(pk: pk, title: title, address: address, lister: lister, listedDate: listedDate, listingDescription: description, numBed: numBed, numBath: numBath, amenities: amenities, genderPreference: genderPreference, startDate: startDate, endDate: endDate, rentPerMonth: rentPerMonth, numTenants: numTenants, fees: fees) //images: images)
    }
    
    
}
