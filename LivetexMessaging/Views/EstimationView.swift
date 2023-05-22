//
//  RateView.swift
//  LivetexMessaging
//
//  Created by Livetex on 30.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

class EstimationView: UIView {

    var onEstimateAction: ((Action) -> Void)?
    var onNextScreenButton: (() -> Void)?
    
    private let nextScreenButton = UIButton()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 16)
        label.textColor = .black
        label.text = "Оцените качество обслуживания"
        return label
    }()

    private lazy var voteUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(asset: .voteUp), for: .normal)
        button.setTitle(nil, for: .normal)
        button.tintColor = .green
        button.tag = Action.up.rawValue
        button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private lazy var voteDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(asset: .voteDown), for: .normal)
        button.setTitle(nil, for: .normal)
        button.tag = Action.down.rawValue
        button.tintColor = .red
        button.addTarget(self, action: #selector(onButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()


    // MARK: - Initialization

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
        backgroundColor = UIColor.groupTableViewBackground
        addSubview(titleLabel)
        addSubview(voteUpButton)
        addSubview(voteDownButton)
        addSubview(separator)
        addSubview(nextScreenButton)
        addAction()
    }

    // MARK: - Action

    @objc private func onButtonTapped(_ sender: UIButton) {
        onEstimateAction?(Action(rawValue: sender.tag) ?? .up)
    }
    func addAction() {
        nextScreenButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
    }

    @objc private func tapButton() {
        onNextScreenButton?()
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        voteDownButton.frame = CGRect(x: bounds.maxX - Layout.voteDownInsets.right - voteUpButton.intrinsicContentSize.width,
                                      y: (bounds.height - voteDownButton.intrinsicContentSize.height) / 2,
                                      width: voteDownButton.intrinsicContentSize.width,
                                      height: voteDownButton.intrinsicContentSize.height)

        voteUpButton.frame = CGRect(x: voteDownButton.frame.minX - Layout.voteUpInsets.right - Layout.imageSize.width,
                                    y: (bounds.height - voteUpButton.intrinsicContentSize.height) / 2,
                                    width: voteUpButton.intrinsicContentSize.width,
                                    height: voteUpButton.intrinsicContentSize.height)

        let rightOffset = voteUpButton.frame.width + voteDownButton.frame.width + Layout.voteUpInsets.right + Layout.voteDownInsets.right
        titleLabel.frame = CGRect(x: Layout.titleInsets.left,
                                  y: (bounds.height - titleLabel.font.lineHeight) / 2,
                                  width: bounds.width - rightOffset - Layout.titleInsets.right,
                                  height: titleLabel.font.lineHeight)

        separator.frame = CGRect(x: 0,
                                 y: bounds.maxY,
                                 width: bounds.width,
                                 height: 0.5)
        nextScreenButton.translatesAutoresizingMaskIntoConstraints = false
        nextScreenButton.setTitle("Next Screen", for: .normal)
        nextScreenButton.backgroundColor = .black
        nextScreenButton.layer.cornerRadius = 8
        NSLayoutConstraint.activate([
            nextScreenButton.heightAnchor.constraint(equalToConstant: 54),
            nextScreenButton.widthAnchor.constraint(equalToConstant: 130),
            nextScreenButton.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            nextScreenButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -6),
        nextScreenButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5)])
            }

    static var viewHeight: CGFloat {
        return 110
    }
}

extension EstimationView {

    enum Action: Int {
        case up
        case down
    }
}

extension EstimationView {

    struct Layout {
        static let titleInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 20)
        static let voteUpInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let voteDownInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        static let imageSize = CGSize(width: 30, height: 30)
    }
}
