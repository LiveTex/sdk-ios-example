//
//  SystemMessageSizeCalculator.swift
//  LivetexMessaging
//
//  Created by Livetex on 14.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class SystemMessageSizeCalculator: MessageSizeCalculator {

    private let textLabelFont: UIFont = .systemFont(ofSize: 13)

    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        let dataSource = messagesLayout.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        let constraintBox = CGSize(width: messagesLayout.itemWidth, height: .greatestFiniteMagnitude)
        guard case let .custom(data) = message.kind, case let .system(text) = data as? CustomType else {
            return .zero
        }

        let attributedText = NSAttributedString(string: text, attributes: [.font: textLabelFont])
        let rect = attributedText.boundingRect(with: constraintBox,
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil).integral
        return CGSize(width: messagesLayout.itemWidth, height: rect.height)
    }

}
