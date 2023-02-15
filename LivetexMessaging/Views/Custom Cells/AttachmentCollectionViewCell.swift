//
//  AttachmentCollectionViewCell.swift
//  LivetexMessaging
//
//  Created by Paul N on 07.02.2023.
//  Copyright © 2023 Livetex. All rights reserved.
//

import MessageKit
import UIKit

internal class AttachmentCollectionViewCell: MessageContentCell {
    /// The label used to display the message's text.
    open var messageLabel = MessageLabel()
    
    /// File icon (static)
    open var fileIconView: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(asset: .fileAttachment)
        return imgView
    }()
    
    var fontToStore: UIFont?
    
    // MARK: - Properties
    /// The `MessageCellDelegate` for the cell.
    open override weak var delegate: MessageCellDelegate? {
        didSet {
            messageLabel.delegate = delegate
        }
    }
    
    // MARK: - Methods
    open override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        if let attributes = layoutAttributes as? MessagesCollectionViewLayoutAttributes {
            messageLabel.textInsets = attributes.messageLabelInsets
            /*messageLabel.messageLabelFont*/fontToStore = attributes.messageLabelFont
            fileIconView.frame = CGRect(x: Dimension.space16, y: Dimension.chatMessageTopTextInset, width: Dimension.fileAttachmentIconWidth, height: Dimension.fileAttachmentIconHeight)
            let frameSize = CGSize(width: messageContainerView.bounds.size.width - CGFloat(Dimension.fileAttachmentIconTotalWidth), height: messageContainerView.bounds.size.height)
            messageLabel.frame = CGRect(origin: CGPoint(x: Dimension.fileAttachmentIconTotalWidth, y: 0), size: frameSize)
        }
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
    }
    
    open override func setupSubviews() {
        super.setupSubviews()
        messageContainerView.addSubview(fileIconView)
        messageContainerView.addSubview(messageLabel)
    }
    
    open override func configure(
        with message: MessageType,
        at indexPath: IndexPath,
        and messagesCollectionView: MessagesCollectionView)
    {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("")
        }
        
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
        
        messageLabel.configure {
            messageLabel.enabledDetectors = enabledDetectors
            for detector in enabledDetectors {
                let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
                messageLabel.setAttributes(attributes, detector: detector)
            }
            let textMessageKind = message.kind
            switch textMessageKind {
            case .custom(let data):
                guard let file = data as? ChatViewModel.AttachmentFile else { return }
                let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
                messageLabel.text = file.name
                messageLabel.textColor = textColor
                if let font = /*messageLabel.messageLabelFont*/fontToStore {
                    messageLabel.font = font
                }
            case .attributedText(let text):
                messageLabel.attributedText = text
            default:
                break
            }
        }
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    open override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        messageLabel.handleGesture(touchPoint)
    }
}
