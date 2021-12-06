//
//  ChatVC.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 9/30/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class ChatVC: MessagesViewController, MessagesDataSource, MessagesLayoutDelegate, MessagesDisplayDelegate, InputBarAccessoryViewDelegate {
    
    var currentUser: SubleaseUserObject!
    var listing: StudentListingObject!
    var sendingSender: Sender!
    var receivingSender: Sender!
    var messages = [MessageType]()
    var messagingTasker: MessagingTasker!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Fix hardcode
        self.currentUser = SubleaseUserObject(pk: 2, email: "ryantobin77@gatech.edu", firstName: "Ryan", lastName: "Tobin", college: "Georgia Institute of Technology")
        self.sendingSender = Sender(senderId: String(self.currentUser.pk), displayName: self.currentUser.firstName + " " + self.currentUser.lastName, user: self.currentUser)
        self.receivingSender = Sender(senderId: String(self.listing.lister.pk), displayName: self.listing.lister.firstName + " " + self.listing.lister.lastName, user: self.listing.lister)
        
        self.navigationItem.title = self.listing.title
                
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        messageInputBar.inputTextView.placeholder = "Send a message..."
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageIncomingAvatarSize(.zero)
        
        self.messagingTasker = MessagingTasker()
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkText
    }
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func currentSender() -> SenderType {
        return sendingSender
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    @objc func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        self.sendMessage(text: text)
    }
    
    func sendMessage(text: String) {
        fatalError("Send Message must be overridden")
    }
    
    func insertMessage(_ message: MessageType) {
        messages.append(message)
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        guard !messages.isEmpty else { return false }
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
}
