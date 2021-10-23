//
//  StudentListingObject.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 9/30/21.
//

import UIKit

class StudentListingObject: NSObject {

    var title: String!
    var address: String!
    var lister: String!
    var listedDate: String!
    var listingDescription: String!
    var numBed: Int!
    var numBath: Double!
    var amenities: Array<String>!
    var genderPreference: String!
    var startDate: String!
    var endDate: String!
    var rentPerMonth: Double!
    var numTenants: Int!
    var fees: Double!
    var numViews: Int!
    var images: Array<UIImage>!
    
    init(title: String, address: String, lister: String, listedDate: String, listingDescription: String, numBed: Int, numBath: Double, amenities: Array<String>, genderPreference: String, startDate: String, endDate: String, rentPerMonth: Double, numTenants: Int, fees: Double, numViews: Int, images: Array<UIImage>) {
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
        self.numViews = numViews
        self.images = images
    }
    
    class func getStudentListings() -> Array<StudentListingObject> {
        var result = Array<StudentListingObject>()
        
        result.append(StudentListingObject(title: "The Mark Atlanta", address: "955 Spring St NW, Atlanta, GA 30309", lister: "Ryan Tobin", listedDate: "09/30/2021", listingDescription: "This is a great listing! Please message me to sublease it", numBed: 4, numBath: 4, amenities: ["Pool", "Gym", "Kitchen", "A/C & Heating"], genderPreference: "None", startDate: "05/02/2022", endDate: "08/02/2022", rentPerMonth: 1250, numTenants: 2, fees: 0, numViews: 5, images: [UIImage(named: "TheMark.jpg")!]))
        
        result.append(StudentListingObject(title: "The Standard Atlanta", address: "708 Spring St NW, Atlanta, GA 30308", lister: "Tejas Vedantham", listedDate: "09/29/2021", listingDescription: "This is a great listing! Please message me to sublease it", numBed: 3, numBath: 3, amenities: ["Pool", "Gym", "Kitchen", "A/C & Heating"], genderPreference: "None", startDate: "05/05/2022", endDate: "08/05/2022", rentPerMonth: 1100, numTenants: 2, fees: 0, numViews: 5, images: [UIImage(named: "TheStandard.jpg")!]))
        
        result.append(StudentListingObject(title: "University House Midtown", address: "930 Spring St NW, Atlanta, GA 30309", lister: "Pooya Nayebi", listedDate: "09/30/2021", listingDescription: "This is a great listing! Please message me to sublease it", numBed: 3, numBath: 3, amenities: ["Pool", "Gym", "Kitchen", "A/C & Heating"], genderPreference: "None", startDate: "06/01/2022", endDate: "09/01/2022", rentPerMonth: 1000, numTenants: 2, fees: 0, numViews: 5, images: [UIImage(named: "UH.jpg")!]))
        
        result.append(StudentListingObject(title: "Square on Fifth", address: "848 Spring St NW, Atlanta, GA 30308", lister: "Mith Verma", listedDate: "09/30/2021", listingDescription: "This is a great listing! Please message me to sublease it", numBed: 4, numBath: 4, amenities: ["Pool", "Gym", "Kitchen", "A/C & Heating"], genderPreference: "None", startDate: "05/01/2022", endDate: "09/01/2022", rentPerMonth: 1400, numTenants: 4, fees: 100, numViews: 5, images: [UIImage(named: "SQ5.jpg")!]))
        
        return result
    }
    
}
