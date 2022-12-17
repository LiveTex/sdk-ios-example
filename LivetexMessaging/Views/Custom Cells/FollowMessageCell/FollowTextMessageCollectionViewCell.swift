//
//  FollowTextMessageCollectionViewCell.swift
//  LivetexMessaging
//
//  Created by Livetex on 06.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class FollowTextMessageCollectionViewCell: MessageContentCell {

    private let followMessageView = FollowMessageView(frame: .zero)
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    private let statusImageView = UIImageView(image: UIImage(asset: .checkmark))
    
    private var messageLabel = MessageLabel()

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.attributedText = nil
        messageLabel.text = nil
        timeLabel.text = nil
        statusImageView.image = nil
        followMessageView.text = nil
    }

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? CustomMessagesCollectionViewLayoutAttributes else {
            return
        }
        messageLabel.textInsets = attributes.messageLabelInsets
        messageLabel.font = attributes.messageLabelFont
        messageLabel.frame = messageContainerView.bounds
        timeLabel.font = attributes.timeLabelFont
        let rightOffset = attributes.timeLabelSize.width + attributes.timeLabelInsets.right
        let bottomOffset = attributes.timeLabelSize.height + attributes.timeLabelInsets.bottom
        let statusWidth = attributes.statusImageSize.width + attributes.statusImageInsets.right
        let statusHeight = attributes.statusImageSize.height + attributes.statusImageInsets.bottom
        statusImageView.frame = CGRect(x: messageContainerView.bounds.width - statusWidth,
                                       y: messageContainerView.bounds.height - statusHeight,
                                       width: attributes.statusImageSize.width,
                                       height: attributes.statusImageSize.height)

        timeLabel.frame = CGRect(x: statusImageView.frame.minX - rightOffset,
                                 y: messageContainerView.bounds.height - bottomOffset,
                                 width: attributes.timeLabelSize.width,
                                 height: attributes.timeLabelSize.height)
        followMessageView.frame = CGRect(x: attributes.followMessageViewInsets.left,
                                         y: attributes.followMessageViewInsets.top,
                                         width: messageContainerView.bounds.width - attributes.followMessageViewInsets.horizontal,
                                         height: 20)
        messageLabel.frame.origin.y = 20
    }

    // MARK: - Configuration

    override func setupSubviews() {
        super.setupSubviews()

        messageContainerView.addSubview(messageLabel)
        messageContainerView.addSubview(timeLabel)
        messageContainerView.addSubview(statusImageView)
        messageContainerView.addSubview(followMessageView)
    }

    override func configure(with message: MessageType,
                            at indexPath: IndexPath,
                            and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            return
        }
        guard let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            fatalError("MessagesLayoutDelegate has not been set.")
        }
        
        let enabledDetectors = displayDelegate.enabledDetectors(for: message, at: indexPath, in: messagesCollectionView)
        
        messageLabel.enabledDetectors = enabledDetectors
        for detector in enabledDetectors {
            let attributes = displayDelegate.detectorAttributes(for: detector, and: message, at: indexPath)
            messageLabel.setAttributes(attributes, detector: detector)
        }
        
        guard case let .custom(data) = message.kind,
              case let .follow(text, messageText) = data as? CustomType,
              let displayDelegate = messagesCollectionView.messagesDisplayDelegate else {
            return
        }
        
        timeLabel.text = DateFormatter.relativeTime.string(from: message.sentDate)
        timeLabel.textColor = dataSource.isFromCurrentSender(message: message) ? .lightText : .lightGray
        statusImageView.image = dataSource.isFromCurrentSender(message: message) ? UIImage(asset: .checkmark) : nil

        let textColor = displayDelegate.textColor(for: message, at: indexPath, in: messagesCollectionView)
        messageLabel.textColor = textColor
        messageLabel.text = messageText
        followMessageView.tintColor = textColor
        followMessageView.isCancelButtonHidden = true
        followMessageView.text = text
    }
    
    /// Used to handle the cell's contentView's tap gesture.
    /// Return false when the contentView does not need to handle the gesture.
    override func cellContentView(canHandle touchPoint: CGPoint) -> Bool {
        return messageLabel.handleGesture(touchPoint)
    }
    
}
