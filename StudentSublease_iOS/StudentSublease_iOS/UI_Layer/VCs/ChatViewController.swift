//
//  ChatViewController.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 9/30/21.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
}

struct Message: MessageType {
    
    var sender: SenderType
    
    var messageId: String
    
    var sentDate: Date
    
    var kind: MessageKind
    
    
}

class ChatViewController: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate {
    
    let currentUser = Sender(senderId: "self", displayName: "Pooya Nayebi")
    let otherUser = Sender(senderId: "self1", displayName: "Ryan Tobin")
    
    var messages = [MessageType]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messages.append(Message(sender: currentUser,
                                messageId: "1",
                                sentDate: Date().addingTimeInterval(-36000),
                                kind: .text("Hello Ryan")))
        messages.append(Message(sender: otherUser,
                                messageId: "2",
                                sentDate: Date().addingTimeInterval(-35000),
                                kind: .text("Hello Pooya")))

        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        // Do any additional setup after loading the view.
    }
    
    
    func currentSender() -> SenderType {
        return currentUser
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section ]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
}
