/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

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
    
    /// The object that manages attachments
    lazy var attachmentManager: AttachmentManager = { [unowned self] in
        let manager = AttachmentManager()
        manager.delegate = self
        return manager
    }()
    
    /// The object that manages autocomplete
    lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
        let manager = AutocompleteManager(for: self.messageInputBar.inputTextView)
        manager.delegate = self
        manager.dataSource = self
        return manager
    }()
    
    let users = ["nathantannar4", "SD10"]
    
    let hastags = ["MessageKit", "MessageInputBar"]
    
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
        tableView.keyboardDismissMode = .interactive
        messageInputBar.delegate = self
        messageInputBar.plugins = [attachmentManager, autocompleteManager]
        
        autocompleteManager.register(prefix: "@", with: [.font: UIFont.preferredFont(forTextStyle: .body),.foregroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 1),.backgroundColor: UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.1)])
        autocompleteManager.register(prefix: "#")
        
        // Want to return custom cells? Set the dataSource
//        attachmentManager.dataSource = self
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

extension ExampleViewController: AttachmentManagerDelegate {
    
    
    // MARK: - AttachmentManagerDelegate
    
    func attachmentManager(_ manager: AttachmentManager, shouldBecomeVisible: Bool) {
        setAttachmentManager(active: shouldBecomeVisible)
    }
    
    func attachmentManager(_ manager: AttachmentManager, didReloadTo attachments: [AttachmentManager.Attachment]) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didInsert attachment: AttachmentManager.Attachment, at index: Int) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didRemove attachment: AttachmentManager.Attachment, at index: Int) {
        messageInputBar.sendButton.isEnabled = manager.attachments.count > 0
    }
    
    func attachmentManager(_ manager: AttachmentManager, didSelectAddAttachmentAt index: Int) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    // MARK: - AttachmentManagerDelegate Helper
    
    func setAttachmentManager(active: Bool) {
        
        let topStackView = messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.insertArrangedSubview(attachmentManager.attachmentView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(attachmentManager.attachmentView) {
            topStackView.removeArrangedSubview(attachmentManager.attachmentView)
            topStackView.layoutIfNeeded()
        }
    }
}

extension ExampleViewController: AutocompleteManagerDelegate, AutocompleteManagerDataSource {
    
    // MARK: - AutocompleteManagerDataSource
    
    func autocompleteManager(_ manager: AutocompleteManager, autocompleteSourceFor prefix: String) -> [AutocompleteCompletion] {
        if prefix == "@" {
            return users.map { AutocompleteCompletion(text: $0) }
        } else if prefix == "#" {
            return hastags.map { AutocompleteCompletion(text: $0) }
        }
        return []
    }
    
    func autocompleteManager(_ manager: AutocompleteManager, tableView: UITableView, cellForRowAt indexPath: IndexPath, for session: AutocompleteSession) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: AutocompleteCell.reuseIdentifier, for: indexPath) as? AutocompleteCell else {
            fatalError("Oops, some unknown error occurred")
        }
        cell.textLabel?.attributedText = manager.attributedText(matching: session, fontSize: 15)
        return cell
    }
    
    // MARK: - AutocompleteManagerDelegate
    
    func autocompleteManager(_ manager: AutocompleteManager, shouldBecomeVisible: Bool) {
        setAutocompleteManager(active: shouldBecomeVisible)
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldRegister prefix: String, at range: NSRange) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldUnregister prefix: String) -> Bool {
        return true
    }
    
    // Optional
    func autocompleteManager(_ manager: AutocompleteManager, shouldComplete prefix: String, with text: String) -> Bool {
        return true
    }
    
    // MARK: - AutocompleteManagerDelegate Helper
    
    func setAutocompleteManager(active: Bool) {
        
        let topStackView = messageInputBar.topStackView
        if active && !topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.insertArrangedSubview(autocompleteManager.tableView, at: topStackView.arrangedSubviews.count)
            topStackView.layoutIfNeeded()
        } else if !active && topStackView.arrangedSubviews.contains(autocompleteManager.tableView) {
            topStackView.removeArrangedSubview(autocompleteManager.tableView)
            topStackView.layoutIfNeeded()
        }
    }
    
}

extension ExampleViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
                let handled = self.attachmentManager.handleInput(of: pickedImage)
                if !handled {
                    // throw error
                }
            }
        })
    }
}
