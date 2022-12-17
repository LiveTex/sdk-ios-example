//
//  ConnectionView.swift
//  LivetexMessaging
//
//  Created by Nikita Fomichev on 29.04.2022.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

final class ConnectionView: UIView {

    private struct Appearance {
        static let titleLabelFont: UIFont = .systemFont(ofSize: 17, weight: .semibold)
        static let titleLabelToActivityIndicatorInset: CGFloat = 16
    }

    // MARK: - Views

    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        return activityIndicator
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Appearance.titleLabelFont
        label.textAlignment = .left
        label.textColor = .black

        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = Appearance.titleLabelToActivityIndicatorInset

        return stackView
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(stackView)
        stackView.addArrangedSubview(activityIndicator)
        stackView.addArrangedSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        stackView.frame = stackViewFrame
    }
}

extension ConnectionView {

    func startActivityIndicator() {
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }

    func stopActivityIndicator() {
        activityIndicator.stopAnimating()
    }

    func setTitle(_ title: String) {
        titleLabel.text = title
    }
}

extension ConnectionView {

    private var stackViewFrame: CGRect {
        let titleLabelWidth = titleLabel.intrinsicContentSize.width
        let activityIndicatorWidth = bounds.height

        let stackViewWidth = activityIndicatorWidth + titleLabelWidth + Appearance.titleLabelToActivityIndicatorInset
        let xCoord = (bounds.width - stackViewWidth) / 2

        return CGRect(x: xCoord, y: 0, width: stackViewWidth, height: bounds.height)
    }
}
