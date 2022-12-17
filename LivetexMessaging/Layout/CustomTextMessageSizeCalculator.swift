//
//  CustomTextMessageSizeCalculator.swift
//  LivetexMessaging
//
//  Created by Livetex on 07.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class CustomTextMessageSizeCalculator: TextMessageSizeCalculator {

    private let timeLabelFont: UIFont = .systemFont(ofSize: 10, weight: .medium)

    private let incomingTimeLabelInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 10)
    private let outgoingTimeLabelInsets = UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 4)
    private let statusImageInsets = UIEdgeInsets(top: 0, left: 4, bottom: 10, right: 16)
    private let statusImageSize = CGSize(width: 16, height: 10)

    func messageLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingMessageLabelInsets : incomingMessageLabelInsets
    }

    func timeLabelInsets(for message: MessageType) -> UIEdgeInsets {
        let dataSource = messagesLayout.messagesDataSource
        let isFromCurrentSender = dataSource.isFromCurrentSender(message: message)
        return isFromCurrentSender ? outgoingTimeLabelInsets : incomingTimeLabelInsets
    }

    private func timeLabelSize(for message: MessageType) -> CGSize {
        let timeAttributedText = NSAttributedString(string: DateFormatter.relativeTime.string(from: message.sentDate),
                                                    attributes: [.font: timeLabelFont])
        return labelSize(for: timeAttributedText, considering: .greatestFiniteMagnitude)
    }

    override func messageContainerMaxWidth(for message: MessageType) -> CGFloat {
        let dataSource = messagesLayout.messagesDataSource
        let maxWidth = super.messageContainerMaxWidth(for: message)
        let timeLabelInset = timeLabelInsets(for: message)
        if dataSource.isFromCurrentSender(message: message) {
            let statusWidth = statusImageInsets.horizontal + statusImageSize.width
            return maxWidth - statusWidth - timeLabelSize(for: message).width - timeLabelInset.horizontal
        } else {
            return maxWidth - timeLabelSize(for: message).width - timeLabelInset.horizontal
        }
    }

    override func messageContainerSize(for message: MessageType) -> CGSize {
        let timeLabelInset = timeLabelInsets(for: message)
        let timeSize = timeLabelSize(for: message)
        let maxWidth = messageContainerMaxWidth(for: message)

        var size: CGSize
        let attributedText: NSAttributedString

        switch message.kind {
        case .attributedText(let text):
            attributedText = text
        case .text(let text), .emoji(let text):
            attributedText = NSAttributedString(string: text, attributes: [.font: messageLabelFont])
        case .custom(let data):
            guard case let .follow(_, text) = data as? CustomType else {
                return .zero
            }

            attributedText = NSAttributedString(string: text, attributes:  [.font: messageLabelFont])
        default:
            return .zero
        }

        size = labelSize(for: attributedText, considering: maxWidth)

        let messageInsets = messageLabelInsets(for: message)
        size.width += messageInsets.horizontal
        size.height += messageInsets.vertical

        if size.height > 36 {
            size.height += timeLabelInset.bottom + timeSize.height
        } else {
            if messagesLayout.messagesDataSource.isFromCurrentSender(message: message) {
                let statusImageWidth = statusImageInsets.horizontal + statusImageSize.width
                size.width += timeLabelInset.left + statusImageWidth + timeSize.width
            } else {
                size.width += timeLabelInset.horizontal + timeSize.width
            }
        }

        return size
    }

    override func configure(attributes: UICollectionViewLayoutAttributes) {
        super.configure(attributes: attributes)
        guard let attributes = attributes as? CustomMessagesCollectionViewLayoutAttributes else {
            return
        }

        let dataSource = messagesLayout.messagesDataSource
        let indexPath = attributes.indexPath
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)

        attributes.timeLabelFont = timeLabelFont
        attributes.timeLabelSize = timeLabelSize(for: message)
        attributes.timeLabelInsets = timeLabelInsets(for: message)
        attributes.statusImageSize = dataSource.isFromCurrentSender(message: message) ? statusImageSize : .zero
        attributes.statusImageInsets = dataSource.isFromCurrentSender(message: message) ? statusImageInsets : .zero
    }

    func labelSize(for attributedText: NSAttributedString, considering maxWidth: CGFloat) -> CGSize {
        let constraintBox = CGSize(width: maxWidth, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox,
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil).integral
        return rect.size
    }

}
