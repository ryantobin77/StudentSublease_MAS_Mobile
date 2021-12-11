//
//  MessagingTasker.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/4/21.
//

import UIKit
import MessageKit

class MessagingTasker: NSObject {

    func startConversation(tenantPk: Int, listingPk: Int, senderPk: Int, message: String, failure: @escaping () -> Void, success: @escaping () -> Void) {
        let webCallTasker: WebCallTasker = WebCallTasker()
        var params = [String: Any]()
        params["tenant_pk"] = tenantPk
        params["listing_pk"] = listingPk
        params["sender_pk"] = senderPk
        params["message"] = message
        webCallTasker.makePostRequest(forURL: BackendURL.START_CONVERSATION_PATH, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 201 {
                failure()
                return
            }
            success()
        })
    }
    
    func getMessages(senderSender: Sender, receiverSender: Sender, conversation: ConversationObject, failure: @escaping () -> Void, success: @escaping (_ messages: Array<Message>) -> Void) {
        let webCallTasker: WebCallTasker = WebCallTasker()
        var params = [String: Any]()
        params["conversation"] = conversation.pk
        params["user_pk"] = senderSender.user.pk
        webCallTasker.makeGetRequest(forBaseURL: BackendURL.GET_MESSAGES_PATH, withParams: params, failure: {
            failure()
        }, success: {(data, response) in
            if response.statusCode != 200 {
                failure()
                return
            }
            let messages = self.parseMessages(senderSender: senderSender, receiverSender: receiverSender, jsonData: data)
            success(messages)
        })
    }
    
    func parseMessages(senderSender: Sender, receiverSender: Sender, jsonData: Data) -> Array<Message> {
        var result: Array<Message> = Array<Message>()
        guard let messages_json = try? JSONSerialization.jsonObject(with: jsonData) as? Array<[String: Any]> else {
            return result
        }
        for message in messages_json {
            let pk = message["pk"] as! Int
            let senderPk = message["sender"] as! Int
            let message_text = message["message"] as! String
            let dateStr = message["date"] as! String
            let date = self.convertStringToDate(dateStr: dateStr)
            print("===== Comparison =====")
            print(senderPk)
            print(senderSender.user.pk!)
            if senderSender.user.pk == senderPk {
                result.append(Message(sender: senderSender, messageId: String(pk), sentDate: date, kind: .text(message_text)))
            } else {
                print("===== Receiver =====")
                print(receiverSender.user.pk)
                result.append(Message(sender: receiverSender, messageId: String(pk), sentDate: date, kind: .text(message_text)))
            }
            print("\n")
        }
        return result
    }
    
    func convertStringToDate(dateStr: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.date(from: dateStr)!
        return date
    }
    
    func convertDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let date = dateFormatter.string(from: date)
        return date
    }
    
    class func getWebSocketPath(for conversation: ConversationObject, user: SubleaseUserObject) -> String {
        return BackendURL.MESSAGING_WEB_SOCKET_PATH + String(conversation.pk) + "/" + String(user.pk)
    }
    
}
