//
//  SubleaseUserObject.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/4/21.
//

import UIKit

class SubleaseUserObject: NSObject {

    var pk: Int!
    var email: String!
    var firstName: String!
    var lastName: String!
    var college: String!
    
    init(pk: Int, email: String, firstName: String, lastName: String, college: String) {
        self.pk = pk
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.college = college
    }
    
    class func parseJson(user_json: [String: Any]) -> SubleaseUserObject? {
        let pk = user_json["pk"] as! Int
        let email = user_json["email"] as! String
        let firstName = user_json["first_name"] as! String
        let lastName = user_json["last_name"] as! String
        let college = user_json["college"] as! String
        return SubleaseUserObject(pk: pk, email: email, firstName: firstName, lastName: lastName, college: college)
    }
    
    class func parseJson(jsonData: Data) -> SubleaseUserObject? {
        guard let user_json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        return parseJson(user_json: user_json)
    }
    
}
