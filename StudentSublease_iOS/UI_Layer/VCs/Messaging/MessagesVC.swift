//
//  MessagesVC.swift
//  StudentSublease_iOS
//
//  Created by Pooya Nayebi on 9/30/21.
//

import UIKit
import Starscream

class MessagesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, WebSocketDelegate {
    
    @IBOutlet var tableView: UITableView!
    var dimmingView: UIView!
    var conversations: Array<ConversationObject>!
    var conversationMap: [Int : ConversationObject]!
    var currentUser: SubleaseUserObject!
    var websockets: [WebSocket]!
    var messagingTasker: MessagingTasker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dimmingView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.dimmingView.backgroundColor = .black
        self.dimmingView.alpha = 0.0
        self.view.addSubview(self.dimmingView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.messagingTasker = MessagingTasker()
        self.currentUser = SubleaseUserObject.getUser(key: "currentUser")!
        self.conversations = Array<ConversationObject>()
        self.conversationMap = [Int : ConversationObject]()
        self.websockets = [WebSocket]()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.conversations = Array<ConversationObject>()
        self.getConversations()
    }
    
    func didReceive(event: WebSocketEvent, client: WebSocket) {
        switch event {
            case .connected(let headers):
                print("Websocket is connected: \(headers)")
            case .disconnected(let reason, let code):
                print("Websocket is disconnected: \(reason) with code: \(code)")
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
                break
            case .error:
                break
        }
    }
    
    func openWebSocket(conversation: ConversationObject) -> WebSocket {
        let urlPath = MessagingTasker.getWebSocketPath(for: conversation, user: self.currentUser)
        let url = URL(string: urlPath)!
        let request = URLRequest(url: url)
        let websocket = WebSocket(request: request)
        websocket.delegate = self
        websocket.connect()
        return websocket
    }
    
    func handleReceivedString(text: String)  {
        guard let data = text.data(using: .utf8) else {
            return
        }
        self.handleReceivedData(data: data)
    }
    
    func handleReceivedData(data: Data) {
        guard let message_json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return
        }
        let conversationPk = message_json["conversation"] as! Int
        let messageText = message_json["message"] as! String
        let conversation = conversationMap[conversationPk]
        conversation?.hasNewMessage = true
        conversation?.lastMessage = messageText
        conversation?.lastMessageDate = self.messagingTasker.convertDateToString(date: Date())
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.conversations.count == 0 {
            let frame = CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height)
            let emptyLabel = UILabel(frame: frame)
            emptyLabel.textAlignment = .center
            
            let icon = UIImage(systemName: "bubble.left.and.bubble.right.fill")
            let iconAttachment = NSTextAttachment(image: icon!)
            let mutableIconString = NSMutableAttributedString(attachment: iconAttachment)
            mutableIconString.append(NSAttributedString(string: " No Conversations!"))
            emptyLabel.attributedText = mutableIconString
            
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = .none
            return 0
        }
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = .singleLine
        return self.conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let conversation = self.conversations[indexPath.row]
        let cell: ConversationCell = self.tableView.dequeueReusableCell(withIdentifier: "conversationCell") as! ConversationCell
        if conversation.receiverPk == conversation.tenant.pk {
            cell.nameLabel.text = conversation.tenant.firstName
        } else {
            cell.nameLabel.text = conversation.listing.lister.firstName
        }
        if conversation.hasNewMessage! {
            cell.newMessageIcon.image = UIImage(systemName: "circle.fill")
            cell.newMessageIcon.isHidden = false
        } else {
            cell.newMessageIcon.image = nil
            cell.newMessageIcon.isHidden = true
        }
        cell.listingTitleLabel.text = conversation.listing.title
        cell.lastMessageLabel.text = conversation.lastMessage
        cell.lastMessageDateLabel.text = conversation.lastMessageDate
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = self.conversations[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ConversationVC()
        vc.listing = conversation.listing
        vc.tenant = conversation.tenant
        vc.conversation = conversation
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getConversations() {
        let loaderView: LoaderView = LoaderView(title: "Loading...", onView: self.dimmingView)
        self.view.addSubview(loaderView)
        loaderView.load()
        ConversationObject.getConversations(userPk: self.currentUser.pk, failure: {
            DispatchQueue.main.async {
                loaderView.stopLoading()
                self.conversations = Array<ConversationObject>()
                self.tableView.reloadData()
            }
        }, success: {(conversationsData) in
            DispatchQueue.main.async {
                if let convos = conversationsData {
                    for conversation in convos {
                        self.conversationMap[conversation.pk] = conversation
                        self.websockets.append(self.openWebSocket(conversation: conversation))
                    }
                    self.conversations = convos
                } else {
                    self.conversations = Array<ConversationObject>()
                }
                loaderView.stopLoading()
                self.tableView.reloadData()
            }
        })
    }
    
}
