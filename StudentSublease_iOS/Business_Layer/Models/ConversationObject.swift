//
//  ConversationObject.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/5/21.
//

import UIKit

class ConversationObject: NSObject {

    var pk: Int!
    var tenant: SubleaseUserObject!
    var listing: StudentListingObject!
    var lastMessage: String!
    var lastMessageDate: String!
    var receiverPk: Int!
    var hasNewMessage: Bool!
    
    init(pk: Int, tenant: SubleaseUserObject, listing: StudentListingObject, lastMessage: String, lastMessageDate: String, receiverPk: Int, hasNewMessage: Bool) {
        self.pk = pk
        self.tenant = tenant
        self.listing = listing
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.receiverPk = receiverPk
        self.hasNewMessage = hasNewMessage
    }
    
    class func getConversations(userPk: Int, failure: @escaping () -> Void, success: @escaping (_ conversations: Array<ConversationObject>?) -> Void) {
        var params = [String: Any]()
        params["user_pk"] = userPk
        let webCallTakser = WebCallTasker()
        webCallTakser.makeGetRequest(forBaseURL: BackendURL.GET_CONVERSATIONS_PATH, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            guard let conversations = try? JSONSerialization.jsonObject(with: data) as? Array<[String: Any]> else {
                failure()
                return
            }
            var result: Array<ConversationObject> = Array<ConversationObject>()
            for conversation in conversations {
                guard let convoData = try? JSONSerialization.data(withJSONObject: conversation, options: []) else {
                    continue
                }
                if let parsedConvo = ConversationObject.parseJson(jsonData: convoData) {
                    result.append(parsedConvo)
                }
            }
            success(result)
        })
    }
    
    class func parseJson(jsonData: Data) -> ConversationObject? {
        guard let conversation_json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: Any] else {
            return nil
        }
        let pk = conversation_json["pk"] as! Int
        let lastMessage = conversation_json["lastMessage"] as! String
        let lastMessageDate = conversation_json["date"] as! String
        let hasNewMessage = conversation_json["has_new_message"] as! Bool
        let receiverPk = conversation_json["receiver_pk"] as! Int
        let listingJson = conversation_json["listing"] as! [String: Any]
        let listing = StudentListingObject.parseJson(listing_json: listingJson)!
        let tenantJson = conversation_json["tenant"] as! [String: Any]
        let tenant = SubleaseUserObject.parseJson(user_json: tenantJson)!
        return ConversationObject(pk: pk, tenant: tenant, listing: listing, lastMessage: lastMessage, lastMessageDate: lastMessageDate, receiverPk: receiverPk, hasNewMessage: hasNewMessage)
    }
    
}
