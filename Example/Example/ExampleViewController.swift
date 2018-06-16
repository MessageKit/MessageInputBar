//
//  ExampleViewController.swift
//  Example
//
//  Created by Nathan Tannar on 2018-06-03.
//  Copyright © 2018 MessageKit. All rights reserved.
//

import UIKit
import MessageInputBar

enum MessageInputBarStyle: String {
    case imessage = "iMessage"
    case slack = "Slack"
    case githawk = "GitHawk"
    case facebook = "Facebook"
    case `default` = "Default"
    
    func generate() -> MessageInputBar {
        switch self {
        case .imessage: return iMessageInputBar()
        case .slack: return SlackInputBar()
        case .githawk: return GitHawkInputBar()
        case .facebook: return FacebookInputBar()
        case .default: return MessageInputBar()
        }
    }
}

final class ExampleViewController: UITableViewController {
    
    // MARK: - Properties
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    // MARK: - MessageInputBar
    
    private let messageInputBar: MessageInputBar
    
    // MARK: Init
    
    init(messageInputBarStyle: MessageInputBarStyle) {
        self.messageInputBar = messageInputBarStyle.generate()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        messageInputBar.delegate = self
        tableView.keyboardDismissMode = .interactive
    }

}

extension ExampleViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Use to send the message
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        // Use to send a typing indicator
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
        // Use to change any other subview insets
    }
    
}

