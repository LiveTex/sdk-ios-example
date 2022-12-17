//
//  ChatViewModel+Messages.swift
//  LivetexMessaging
//
//  Created by Livetex on 19.05.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit
import LivetexCore

enum CustomType {
    case system(String)
    case follow(String, String)
}

extension ChatViewModel {

    struct ChatMessage: MessageType, Hashable {
        var sender: SenderType
        var messageId: String
        var sentDate: Date
        var kind: MessageKind
        var creator: Creator
        var keyboard: Keyboard?

        // MARK: - Hashable

        func hash(into hasher: inout Hasher) {
            return hasher.combine(messageId)
        }

        static func == (lhs: ChatViewModel.ChatMessage, rhs: ChatViewModel.ChatMessage) -> Bool {
            return lhs.messageId == rhs.messageId
        }

    }

    struct Recipient: SenderType {
        var senderId: String
        var displayName: String
    }

    struct File: MediaItem {
        var url: URL?

        var image: UIImage?

        var placeholderImage: UIImage

        var size: CGSize

        // MARK: - Initialization

        init(url: String,
             image: UIImage? = nil,
             placeholderImage: UIImage = UIImage(),
             size: CGSize = CGSize(width: 240, height: 240)) {
            self.url = URL(string: url, relativeTo: URL(string: "https://"))
            self.image = image
            self.placeholderImage = placeholderImage
            self.size = size
        }
    }

}
