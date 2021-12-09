//
//  BackendURL.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 10/23/21.
//

import UIKit

class BackendURL: NSObject {
    static let HTTP_PROTOCOL = "http://"
    static let WS_PROTOCOL = "ws://"
    static let HOST = "127.0.0.1:8000"
    
    static let BASE_PATH = HTTP_PROTOCOL + HOST
    static let API_PATH = BASE_PATH + "/api"
    
    // Sublease Endpoints
    static let SUBLEASE_PATH = API_PATH + "/sublease"
    static let SEARCH_LISTINGS_PATH = SUBLEASE_PATH + "/search"
    static let CREATE_LISTING_PATH = SUBLEASE_PATH + "/listing/create"
    static let DELETE_LISTING_PATH = SUBLEASE_PATH + "/listing/delete"
    
    // Messaging Endpoints
    static let MESSAGING_PATH = API_PATH + "/messaging"
    static let START_CONVERSATION_PATH = MESSAGING_PATH + "/conversation/new"
    static let GET_CONVERSATIONS_PATH = MESSAGING_PATH + "/conversations"
    static let GET_MESSAGES_PATH = MESSAGING_PATH + "/messages"
    static let MESSAGING_WEB_SOCKET_PATH = WS_PROTOCOL + HOST + "/ws/messages/"
    
    // User Endpoints
    static let USER_PATH = API_PATH + "/users"
    static let SIGN_UP = USER_PATH + "/signup"
    static let LOGIN = USER_PATH + "/login"
    static let LOGOUT = USER_PATH + "/logout"
}
