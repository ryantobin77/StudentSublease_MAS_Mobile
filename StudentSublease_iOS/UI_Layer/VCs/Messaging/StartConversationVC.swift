//
//  StartConversationVC.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/4/21.
//

import UIKit
import MessageKit
import InputBarAccessoryView

class StartConversationVC: ChatVC {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func sendMessage(text: String) {
        let message: Message = Message(sender: sendingSender, messageId: "1", sentDate: Date(), kind: .text(text))
        let failureMessage: Message = Message(sender: sendingSender, messageId: "1", sentDate: Date(), kind: .text("Sorry something went wrong. Please try again!"))
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        messageInputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            self.messagingTasker.startConversation(tenantPk: self.currentUser.pk, listingPk: self.listing.pk, senderPk: self.currentUser.pk, message: text, failure: {
                DispatchQueue.main.async { [weak self] in
                    self?.messageInputBar.sendButton.stopAnimating()
                    self?.messageInputBar.inputTextView.placeholder = "Send a message..."
                    self?.insertMessage(failureMessage)
                    self?.messagesCollectionView.scrollToLastItem(animated: true)
                }
            }, success: {
                DispatchQueue.main.async { [weak self] in
                    self?.messageInputBar.sendButton.stopAnimating()
                    self?.messageInputBar.inputTextView.placeholder = "Send a message..."
                    self?.insertMessage(message)
                    self?.messagesCollectionView.scrollToLastItem(animated: true)
                }
            })
        }
    }
    
}
