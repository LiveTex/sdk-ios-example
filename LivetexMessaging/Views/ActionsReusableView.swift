//
//  ActionsReusableView.swift
//  LivetexMessaging
//
//  Created by Emil Abduselimov on 28.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit
import LivetexCore

class ActionsReusableView: MessageReusableView {

    var onAction: ((Button) -> Void)?

    private var buttons: [Button] = []

    private static let buttonHeight: CGFloat = 44

    private static let padding: CGFloat = 10

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        subviews.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Configuration

    func configure(with keyboard: Keyboard) {
        self.buttons = keyboard.buttons
        subviews.forEach { $0.removeFromSuperview() }
        for (index, item) in buttons.enumerated() {
            let button = UIButton(type: .custom)
            button.setTitle(item.label, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.tintColor = .messageBlue
            button.titleLabel?.numberOfLines = 0
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.isEnabled = !keyboard.pressed
            button.setBackgroundImage(UIImage(asset: .defaultBackground), for: .normal)
            button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
            button.tag = index
            addSubview(button)
        }
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        var offset: CGFloat = 0
        for button in subviews {
            button.frame = CGRect(x: 0,
                                  y: ActionsReusableView.padding + offset,
                                  width: bounds.width,
                                  height: ActionsReusableView.buttonHeight).insetBy(dx: 20, dy: 0)
            offset += ActionsReusableView.buttonHeight + ActionsReusableView.padding
        }
    }

    // MARK: - Action

    @objc private func onButtonTapped(_ sender: UIButton) {
        let button = buttons[sender.tag]
        onAction?(button)
    }

    static func viewHeight(for keyboard: Keyboard) -> CGFloat {
        return CGFloat(keyboard.buttons.count) * (buttonHeight + padding)
    }
    
}
