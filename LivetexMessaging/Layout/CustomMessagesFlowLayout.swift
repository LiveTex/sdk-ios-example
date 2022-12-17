//
//  CustomMessagesFlowLayout.swift
//  LivetexMessaging
//
//  Created by Livetex on 07.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class CustomMessagesFlowLayout: MessagesCollectionViewFlowLayout {

    private lazy var followTextMessageSizeCalculator = FollowTextMessageSizeCalculator(layout: self)
    private lazy var customTextMessageSizeCalculator = CustomTextMessageSizeCalculator(layout: self)
    private lazy var systemMessageSizeCalculator = SystemMessageSizeCalculator(layout: self)

    override class var layoutAttributesClass: AnyClass {
        return CustomMessagesCollectionViewLayoutAttributes.self
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray = super.layoutAttributesForElements(in: rect) as? [CustomMessagesCollectionViewLayoutAttributes] else {
            return nil
        }
        for attributes in attributesArray where attributes.representedElementCategory == .cell {
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItem(at: indexPath) as? CustomMessagesCollectionViewLayoutAttributes else {
            return nil
        }
        if attributes.representedElementCategory == .cell {
            let cellSizeCalculator = cellSizeCalculatorForItem(at: attributes.indexPath)
            cellSizeCalculator.configure(attributes: attributes)
        }
        return attributes
    }

    override func cellSizeCalculatorForItem(at indexPath: IndexPath) -> CellSizeCalculator {
        if isSectionReservedForTypingIndicator(indexPath.section) {
            return typingIndicatorSizeCalculator
        }
        let message = messagesDataSource.messageForItem(at: indexPath, in: messagesCollectionView)
        switch message.kind {
        case .text, .emoji:
            return customTextMessageSizeCalculator
        case let .custom(value):
            guard let type = value as? CustomType else {
                return super.cellSizeCalculatorForItem(at: indexPath)
            }

            switch type {
            case .system:
                return systemMessageSizeCalculator
            case .follow:
                return followTextMessageSizeCalculator
            }
        default:
            return super.cellSizeCalculatorForItem(at: indexPath)
        }
    }

    override func messageSizeCalculators() -> [MessageSizeCalculator] {
        var calculators = super.messageSizeCalculators()
        calculators.append(customTextMessageSizeCalculator)
        calculators.append(systemMessageSizeCalculator)
        calculators.append(followTextMessageSizeCalculator)
        return calculators
    }

}
