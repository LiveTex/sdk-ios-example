//
//  FollowTextMessageSizeCalculator.swift
//  LivetexMessaging
//
//  Created by Livetex on 06.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class FollowTextMessageSizeCalculator: CustomTextMessageSizeCalculator {

    private let followMessageViewSize = CGSize(width: 0, height: 20)

    override func messageContainerSize(for message: MessageType) -> CGSize {
        let size = super.messageContainerSize(for: message)
        return CGSize(width: size.width, height: size.height + followMessageViewSize.height)
    }

}
