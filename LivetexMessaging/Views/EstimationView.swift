//
//  RateView.swift
//  LivetexMessaging
//
//  Created by Livetex on 30.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

class EstimationView: UIView {

    var rating: String?
    var onEstimateAction: (() -> Void)?

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.grayFont
        label.layer.opacity = 0.88
        label.text = "Оцените качество обслуживания"
        return label
    }()

    private lazy var voteUpButton: UIButton = {
        let button = UIButton(type: .custom)
        if rating == nil {
            button.setImage(UIImage(asset: .voteUpGray), for: .normal)
        } else {
            button.setImage(UIImage(asset: .voteUpGreen), for: .normal)
        }
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.setTitle(nil, for: .normal)
        return button
    }()

    private lazy var voteDownButton: UIButton = {
        let button = UIButton(type: .custom)
        if rating == nil {
            button.setImage(UIImage(asset: .voteDownGray), for: .normal)
        } else {
            button.setImage(UIImage(asset: .voteDownRed), for: .normal)
        }
        button.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
        button.setTitle(nil, for: .normal)
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
        backgroundColor = UIColor.grayBackground
        addSubview(titleLabel)
        addSubview(voteUpButton)
        addSubview(voteDownButton)
        addSubview(separator)
    }
    
    func voteConfig(_ rating: String? = nil) {
        
        if let rating = rating {
            
            if rating == "1" {
                //  voteUpButton.isEnabled = true
                voteUpButton.setImage(UIImage(asset: .voteUpGreen), for: .normal)
                voteDownButton.setImage(UIImage(asset: .voteDownGray), for: .normal)
                //  voteDownButton.isEnabled = true
            } else {
                voteDownButton.setImage(UIImage(asset: .voteDownRed), for: .normal)
                voteUpButton.setImage(UIImage(asset: .voteUpGray), for: .normal)
            }
        } else {
            voteDownButton.setImage(UIImage(asset: .voteDownGray), for: .normal)
            voteUpButton.setImage(UIImage(asset: .voteUpGray), for: .normal)
        }
        // self.setNeedsDisplay()
    }
    

    // MARK: - Action



    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addSubview(titleLabel)
        self.addSubview(voteUpButton)
        self.addSubview(voteDownButton)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        voteUpButton.translatesAutoresizingMaskIntoConstraints = false
        voteDownButton.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        NSLayoutConstraint.activate([
            voteUpButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            voteUpButton.widthAnchor.constraint(equalToConstant: 22),
            voteUpButton.heightAnchor.constraint(equalToConstant: 20)

        ])
        NSLayoutConstraint.activate([
            voteDownButton.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            voteDownButton.leadingAnchor.constraint(equalTo: voteUpButton.trailingAnchor, constant: 16),
            voteDownButton.widthAnchor.constraint(equalToConstant: 22),
            voteDownButton.heightAnchor.constraint(equalToConstant: 20),
            voteDownButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])

        separator.frame = CGRect(x: 0,
                                 y: bounds.maxY,
                                 width: bounds.width,
                                 height: 0.5)
            }

    static var viewHeight: CGFloat {
        return 38
    }
    
    @objc private func onButtonTapped() {
        onEstimateAction?()
    }
}
