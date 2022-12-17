//
//  TitleView.swift
//  LivetexMessaging
//
//  Created by Livetex on 19.05.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

final class DialogueStateView: UIView {

    private struct Appearance {
        static let titleLabelFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        static let subtitleLabelFont: UIFont = .systemFont(ofSize: 13)

        static let connectionViewText: String = "connecting"
    }

    var title: String? {
        get {
            return titleLabel.text
        }
        set {
            if newValue != title {
                titleLabel.text = newValue
                setNeedsLayout()
            }
        }
    }

    var subtitle: String? {
        get {
            return subtitleLabel.text
        }
        set {
            if newValue != subtitle {
                subtitleLabel.text = newValue
                subtitleLabel.isHidden = newValue?.isEmpty ?? true
                setNeedsLayout()
            }
        }
    }

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.titleLabelFont
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = Appearance.subtitleLabelFont
        label.textAlignment = .center
        label.textColor = .black
        label.isHidden = true
        return label
    }()

    private lazy var connectionView: ConnectionView = {
        let connectionView = ConnectionView()
        connectionView.translatesAutoresizingMaskIntoConstraints = false

        return connectionView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        addSubview(subtitleLabel)
        addSubview(connectionView)

        connectionView.setTitle(Appearance.connectionViewText)
        setConnectionInProgress()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        titleLabel.frame = CGRect(x: 0,
                                  y: 0,
                                  width: bounds.width,
                                  height: subtitleLabel.isHidden ? bounds.height : titleLabel.font.lineHeight)

        subtitleLabel.frame = CGRect(x: 0,
                                     y: titleLabel.frame.maxY,
                                     width: bounds.width,
                                     height: subtitleLabel.font.lineHeight)

        connectionView.frame = CGRect(x: 0,
                                      y: 0,
                                      width: bounds.width,
                                      height: bounds.height)
    }
}

extension DialogueStateView {

    func setConnectionInProgress() {
        connectionView.isHidden = false
        connectionView.startActivityIndicator()
    }

    func setConnectedSuccessfully() {
        connectionView.isHidden = true
        connectionView.stopActivityIndicator()
    }
}
