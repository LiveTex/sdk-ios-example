//
//  AttachmentFileSizeCalculator.swift
//  LivetexMessaging
//
//  Created by Paul N on 09.02.2023.
//  Copyright © 2023 Livetex. All rights reserved.
//

import Foundation
import MessageKit
import UIKit

class AttachmentFileSizeCalculator: MessageSizeCalculator {
    // MARK: Open
    open override func messageContainerMaxWidth(for message: MessageType, at indexPath: IndexPath) -> CGFloat {
        let maxWidth = super.messageContainerMaxWidth(for: message, at: indexPath)
        let textInsets = messageLabelInsets(for: message)
        return maxWidth - textInsets.horizontal
    }
    
    open override func messageContainerSize(for message: MessageType, at indexPath: IndexPath) -> CGSize {
        let maxWidth = messageContainerMaxWidth(for: message, at: indexPath)
        
        var messageContainerSize: CGSize
        let attributedText: NSAttributedString
        
        let textMessageKind = message.kind
        switch textMessageKind {
        case .attributedText(let text):
            attributedText = text
        case .custom(let data):
            guard let file = data as? ChatViewModel.AttachmentFile else
            {
                return .zero
            }
            attributedText = NSAttributedString(string: file.name ?? "", attributes: [.font: messageLabelFont])
        default:
            fatalError("messageContainerSize received unhandled MessageDataType: \(message.kind)")
        }
        
        messageContainerSize = attributedText.size(consideringWidth: maxWidth - CGFloat(Dimension.fileAttachmentIconTotalWidth))
        
        let messageInsets = messageLabelInsets(for: message)
        messageContainerSize.width += messageInsets.horizontal + CGFloat(Dimension.fileAttachmentIconTotalWidth)
        messageContainerSize.height += messageInsets.vertical
        
        return messageContainerSize
    }
    
    open override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? MessagesCollectionViewLayoutAttributes else { return }
        
        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        
        attributes.messageLabelInsets = messageLabelInsets(for: message)
        attributes.messageLabelFont = messageLabelFont
    }
    
    // MARK: Public
    public var incomingMessageLabelInsets = UIEdgeInsets(top: 7, left: 18, bottom: 7, right: 14)
    public var outgoingMessageLabelInsets = UIEdgeInsets(top: 7, left: 14, bottom: 7, right: 18)
    
    public var messageLabelFont = UIFont.preferredFont(forTextStyle: .body)
    
    // MARK: Internal
    internal func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }
}
