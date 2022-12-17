//
//  FollowMessageView.swift
//  LivetexMessaging
//
//  Created by Livetex on 05.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

final class FollowMessageView: UIView {

    var onCancelAction: (() -> Void)?

    var isCancelButtonHidden = false {
        didSet {
            cancelButton.isHidden = isCancelButtonHidden
        }
    }

    var textColor: UIColor = .messageBlue {
        didSet {
            textLabel.textColor = textColor
        }
    }

    var text: String? {
        get {
            return textLabel.text
        }
        set {
            textLabel.text = newValue
        }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 0, height: 24)
    }

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let borderView: UIView = {
        let view = UIView()
        view.backgroundColor = .messageBlue
        return view
    }()

    private let cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .messageBlue
        button.setImage(UIImage(asset: .cancel), for: .normal)
        button.setTitle(nil, for: .normal)
        return button
    }()

    // MARK: - Initialization

    convenience init(name: String?, text: String?) {
        self.init(frame: .zero)
        self.text = text
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        configure()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        configure()
    }

    // MARK: - Configuration

    private func configure() {
        addSubview(borderView)
        addSubview(textLabel)
        addSubview(cancelButton)

        cancelButton.addTarget(self, action: #selector(onCancelTapped), for: .touchUpInside)
    }

    override func tintColorDidChange() {
        super.tintColorDidChange()
        borderView.backgroundColor = tintColor
        cancelButton.tintColor = tintColor
        textLabel.textColor = tintColor
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        borderView.frame = CGRect(x: Layout.bordertViewInsets.left,
                                  y: Layout.bordertViewInsets.top,
                                  width: 2,
                                  height: bounds.height - Layout.bordertViewInsets.vertical)

        cancelButton.frame = CGRect(x: bounds.width - Layout.cancelButtonSize.width - Layout.cancelButtonInsets.right,
                                    y: (bounds.height - Layout.cancelButtonSize.height) / 2,
                                    width: Layout.cancelButtonSize.width,
                                    height: Layout.cancelButtonSize.height)

        let rightOffset = Layout.cancelButtonSize.width + borderView.frame.width + Layout.cancelButtonInsets.right
        textLabel.frame = CGRect(x: borderView.frame.maxX + Layout.textLabelInsets.left,
                                 y: Layout.textLabelInsets.top,
                                 width: bounds.width - rightOffset - Layout.textLabelInsets.horizontal,
                                 height: bounds.height - Layout.textLabelInsets.vertical)
    }

    // MARK: - Action

    @objc private func onCancelTapped() {
        onCancelAction?()
    }

}

extension FollowMessageView {

    struct Layout {
        static let cancelButtonSize = CGSize(width: 20, height: 20)
        static let bordertViewInsets = UIEdgeInsets(top: 2, left: 0, bottom: 2, right: 0)
        static let textLabelInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        static let cancelButtonInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }

}
