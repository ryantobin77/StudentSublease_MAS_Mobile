//
//  MessagingStructs.swift
//  StudentSublease_iOS
//
//  Created by Ryan Tobin on 12/4/21.
//

import UIKit
import MessageKit

struct Sender: SenderType {
    var senderId: String
    var displayName: String
    var user: SubleaseUserObject
}

struct Message: MessageType {
    var sender: SenderType
    var messageId: String
    var sentDate: Date
    var kind: MessageKind
}
