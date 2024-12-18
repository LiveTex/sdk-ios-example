//
//  RateViewSizeCalculator.swift
//  LivetexMessaging
//
//  Created by Yuri on 05.12.2024.
//  Copyright © 2024 Livetex. All rights reserved.
//

import Foundation

import UIKit
import MessageKit
import LivetexCore

class RateViewSizeCalculator: MessageSizeCalculator {
    
    
    override func sizeForItem(at indexPath: IndexPath) -> CGSize {
        
        let dataSource = messagesLayout.messagesDataSource
        let message = dataSource.messageForItem(at: indexPath, in: messagesLayout.messagesCollectionView)
        
        guard case let .custom(data) = message.kind,
              var modelRate = data as? Rate else {
            return .zero
        }

        var comment = modelRate.commentEnabled ? 60 : 0
        var hightBeforeTitle = (modelRate.textBefore ?? "").count == 0 ? 0 : 16
        var hightAfterTitle = (modelRate.textAfter ?? "").count == 0 ? 0 : 32
        var hightCommentTitle = (modelRate.isSet?.comment?.count ?? 0) == 0 ? 0 : 16
        
        var titleBefore: Int
        if (modelRate.textBefore ?? "").count == 0 {
            titleBefore = 0
        } else {
            titleBefore = Int(labelSize(for: modelRate.textBefore ?? "", fontSize: 14).height)
        }
        var titleAfter: Int
        if (modelRate.textAfter ?? "").count == 0 {
            titleAfter = 0
        } else {
            titleAfter = Int(labelSize(for: (modelRate.textAfter ?? ""), fontSize: 14).height)
        }
        var titleComment: Int
        if modelRate.isSet?.comment?.count == 0 {
            titleComment = 0
        } else {
            titleComment = Int(labelSize(for: modelRate.isSet?.comment ?? "", fontSize: 12).height)
        }
        
        if let setRate = modelRate.isSet {
            var sum = 46 + hightAfterTitle + hightCommentTitle
            return CGSize(width: Int(UIScreen.main.bounds.width) - 32, height: sum + titleComment + titleAfter)
        } else {
            var sum = 125 + comment + hightBeforeTitle
            if modelRate.enabledType == .fivePoint {
                return CGSize(width: Int(UIScreen.main.bounds.width) - 32, height: sum + titleBefore)
            } else {
                return CGSize(width: Int(UIScreen.main.bounds.width) - 32, height: sum + titleBefore)
            }
        }
    }
    
    func labelSize(for text: String, fontSize: Int) -> CGSize {
        
        let attributedText = NSAttributedString(string: text, attributes:  [.font: UIFont.systemFont(ofSize: CGFloat(fontSize))])
        let constraintBox = CGSize(width: UIScreen.main.bounds.width - 64, height: .greatestFiniteMagnitude)
        let rect = attributedText.boundingRect(with: constraintBox,
                                               options: [.usesLineFragmentOrigin, .usesFontLeading],
                                               context: nil).integral
        return rect.size
    }
}
