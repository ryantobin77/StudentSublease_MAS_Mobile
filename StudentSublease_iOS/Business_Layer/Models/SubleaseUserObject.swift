//
//  SubleaseUserObject.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/4/21.
//

import UIKit

class SubleaseUserObject: NSObject, Codable {

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
    
    func saveUser(key: String) -> Bool {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            UserDefaults.standard.set(data, forKey: key)
            return true
        } catch {
            print("Unable to Encode User (\(error))")
            return false
        }
    }
    
    class func getUser(key: String) -> SubleaseUserObject? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SubleaseUserObject.self, from: data)
            return user
        } catch {
            print("Unable to Decode User (\(error))")
            return nil
        }
    }
    
    class func removeUser(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func logout(failure: @escaping () -> Void, success: @escaping () -> Void) {
        let params = [String: Any]()
        WebCallTasker().makePostRequest(forURL: BackendURL.LOGOUT, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if (response.statusCode != 200) {
               failure()
            } else {
                SubleaseUserObject.removeUser(key: "currentUser")
                success()
            }
        })
    }
    
    class func loginUser(email: String, password: String, failure: @escaping () -> Void, success: @escaping (_ user: SubleaseUserObject) -> Void) {
        var params = [String: Any]()
        params["email"] = email
        params["password"] = password
        WebCallTasker().makePostRequest(forURL: BackendURL.LOGIN, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if (response.statusCode != 200) {
                failure()
            } else {
                let user = SubleaseUserObject.parseJson(jsonData: data)!
                if user.saveUser(key: "currentUser") {
                    success(user)
                } else {
                    failure()
                }
            }
        })
    }
    
}
