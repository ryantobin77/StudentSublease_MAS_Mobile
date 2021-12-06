//
//  ConversationVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/5/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import Starscream

class ConversationVC: ChatVC, WebSocketDelegate {
    
    var conversation: ConversationObject!
    var dimmingView: UIView!
    var websocket: WebSocket!
    var isConnected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        self.openWebSocket()
        self.getMessages()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isConnected {
            self.websocket.disconnect()
        }
    }
    
    func getMessages() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        self.messagingTasker.getMessages(senderSender: self.sendingSender, receiverSender: self.receivingSender, conversation: self.conversation, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
            }
        }, success: {(messages) in
            DispatchQueue.main.async {
                for message in messages {
                    self.insertMessage(message)
                }
                self.messagesCollectionView.scrollToLastItem(animated: true)
                loaderView.stopLoading()
            }
        })
    }
    
    func openWebSocket() {
        let urlPath = MessagingTasker.getWebSocketPath(for: self.conversation, user: self.currentUser)
        let url = URL(string: urlPath)!
        let request = URLRequest(url: url)
        self.websocket = WebSocket(request: request)
        self.websocket.delegate = self
        self.websocket.connect()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                isConnected = true
                print("websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                isConnected = false
                print("websocket is disconnected: \(reason) with code: \(code)")
            case .text(let string):
                self.handleReceivedString(text: string)
            case .binary(let data):
                self.handleReceivedData(data: data)
            case .ping(_):
                break
            case .pong(_):
                break
            case .viabilityChanged(_):
                break
            case .reconnectSuggested(_):
                break
            case .cancelled:
                isConnected = false
            case .error:
                isConnected = false
                let failureMessage: Message = Message(sender: sendingSender, messageId: "-1", sentDate: Date(), kind: .text("Sorry something went wrong. Please try again!"))
                self.insertMessage(failureMessage)
        }
    }
    
    func handleReceivedString(text: String)  {
        let failureMessage: Message = Message(sender: sendingSender, messageId: "1", sentDate: Date(), kind: .text("Sorry something went wrong. Please try again!"))
        guard let data = text.data(using: .utf8) else {
            self.insertMessage(failureMessage)
            return
        }
        self.handleReceivedData(data: data)
    }
    
    func handleReceivedData(data: Data) {
        let failureMessage: Message = Message(sender: sendingSender, messageId: "1", sentDate: Date(), kind: .text("Sorry something went wrong. Please try again!"))
        guard let message_json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            self.insertMessage(failureMessage)
            return
        }
        let messageText = message_json["message"] as! String
        let senderPk = message_json["sender"] as! Int
        
        var message: Message = Message(sender: sendingSender, messageId: "-1", sentDate: Date(), kind: .text(messageText))
        if senderPk != self.currentUser.pk {
            message = Message(sender: receivingSender, messageId: "-1", sentDate: Date(), kind: .text(messageText))
        }
        self.insertMessage(message)
    }
    
    override func sendMessage(text: String) {
        let senderPk = String(self.currentUser.pk)
        let sendingMessage: String = "{\"message\":\"\(text)\", \"sender\":\(senderPk)}"
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        messageInputBar.inputTextView.resignFirstResponder()
        self.websocket.write(string: sendingMessage, completion: {
            // DispatchQueue.global(qos: .default).async {
            DispatchQueue.main.async {
                self.messageInputBar.sendButton.stopAnimating()
                self.messageInputBar.inputTextView.placeholder = "Send a message..."
            }
        })
    }

}
