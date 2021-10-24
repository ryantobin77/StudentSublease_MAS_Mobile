//
//  BackendURL.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class BackendURL: NSObject {
    static let BASE_PATH = "http://127.0.0.1:8000"
    static let API_PATH = BASE_PATH + "/api"
    
    // Sublease Endpoints
    static let SUBLEASE_PATH = API_PATH + "/sublease"
    static let SEARCH_LISTINGS_PATH = SUBLEASE_PATH + "/search"
    static let CREATE_LISTING_PATH = SUBLEASE_PATH + "/listing/create"
    
}
