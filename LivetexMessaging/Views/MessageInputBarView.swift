//
//  MessageInputBarView.swift
//  LivetexMessaging
//
//  Created by Livetex on 06.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import InputBarAccessoryView

class MessageInputBarView: InputBarAccessoryView {

    var onAttachmentButtonTapped: (() -> Void)?

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        configure()
    }

    // MARK: - Configuration

    private func configure() {
        backgroundColor = .white
        separatorLine.isHidden = true
        inputTextView.backgroundColor = .white
        inputTextView.textColor = .black
        inputTextView.placeholder = "Введите сообщение"
        topStackViewPadding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)

        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 6, bottom: 8, right: 6)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10)
        middleContentViewPadding.left = 6
        middleContentViewPadding.right = 6
        inputTextView.layer.borderWidth = 0.8
        inputTextView.layer.cornerRadius = 16
        inputTextView.layer.masksToBounds = true
        inputTextView.autocorrectionType = .yes
        inputTextView.layer.borderColor = UIColor.messageGray.cgColor

        let attachmentButton = InputBarButtonItem().configure {
                $0.image = UIImage(asset: .attachment)?.withRenderingMode(.alwaysTemplate)
                $0.tintColor = sendButton.tintColor
                $0.setSize(CGSize(width: 36, height: 36), animated: false)
            }.onTouchUpInside { [weak self] item in
                self?.onAttachmentButtonTapped?()
            }

        setLeftStackViewWidthConstant(to: 25, animated: false)
        setStackViewItems([attachmentButton], forStack: .left, animated: false)

        setRightStackViewWidthConstant(to: 28, animated: false)
        sendButton.image = UIImage(asset: .send)
        sendButton.setSize(CGSize(width: 36, height: 36), animated: false)
        sendButton.imageView?.layer.cornerRadius = 16
    }

}
