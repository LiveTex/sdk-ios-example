//
//  CustomMessagesCollectionViewLayoutAttributes.swift
//  LivetexMessaging
//
//  Created by Livetex on 07.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class CustomMessagesCollectionViewLayoutAttributes: MessagesCollectionViewLayoutAttributes {

    var timeLabelFont: UIFont = .systemFont(ofSize: 10, weight: .medium)
    var timeLabelSize: CGSize = .zero
    var timeLabelInsets = UIEdgeInsets(top: 0, left: 6, bottom: 8, right: 6)
    var statusImageInsets: UIEdgeInsets = .zero
    var statusImageSize = CGSize(width: 16, height: 10)
    var followMessageViewInsets = UIEdgeInsets(top: 4, left: 15, bottom: 0, right: 15)

    override func copy(with zone: NSZone? = nil) -> Any {
        // swiftlint:disable force_cast
        let copy = super.copy(with: zone) as! CustomMessagesCollectionViewLayoutAttributes
        copy.timeLabelSize = timeLabelSize
        copy.timeLabelFont = timeLabelFont
        copy.timeLabelInsets = timeLabelInsets
        copy.statusImageSize = statusImageSize
        copy.statusImageInsets = statusImageInsets
        return copy
        // swiftlint:enable force_cast
    }

    open override func isEqual(_ object: Any?) -> Bool {
        guard let attributes = object as? CustomMessagesCollectionViewLayoutAttributes else {
            return false
        }

        return super.isEqual(object) && attributes.timeLabelInsets == timeLabelInsets
            && attributes.timeLabelSize == timeLabelSize
            && attributes.timeLabelFont == timeLabelFont
            && attributes.statusImageInsets == statusImageInsets
            && attributes.statusImageSize == statusImageSize
    }
}
