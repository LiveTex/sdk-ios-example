//
//  TextMessageCollectionViewCell.swift
//  LivetexMessaging
//
//  Created by Livetex on 07.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class TextMessageCollectionViewCell: TextMessageCell {

    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()

    private let statusImageView = UIImageView(image: UIImage(asset: .checkmark))

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()
        timeLabel.text = nil
        statusImageView.image = nil
    }

    // MARK: - Layout attributes

    override func apply(_ layoutAttributes: UICollectionViewLayoutAttributes) {
        super.apply(layoutAttributes)
        guard let attributes = layoutAttributes as? CustomMessagesCollectionViewLayoutAttributes else {
            return
        }

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
    }

    // MARK: - Configuration

    override func setupSubviews() {
        super.setupSubviews()

        messageContainerView.addSubview(timeLabel)
        messageContainerView.addSubview(statusImageView)
    }

    override func configure(with message: MessageType,
                            at indexPath: IndexPath,
                            and messagesCollectionView: MessagesCollectionView) {
        super.configure(with: message, at: indexPath, and: messagesCollectionView)
        timeLabel.text = DateFormatter.relativeTime.string(from: message.sentDate)
        guard let dataSource = messagesCollectionView.messagesDataSource else {
            return
        }

        timeLabel.textColor = dataSource.isFromCurrentSender(message: message) ? .lightText : .lightGray
        statusImageView.image = dataSource.isFromCurrentSender(message: message) ? UIImage(asset: .checkmark) : nil
    }

}
