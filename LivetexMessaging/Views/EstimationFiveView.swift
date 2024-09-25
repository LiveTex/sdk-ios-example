//
//  EstimationFiveView.swift
//  LivetexMessaging
//
//  Created by Yuri on 19.09.2024.
//  Copyright © 2024 Livetex. All rights reserved.
//

import UIKit

class EstimationFiveView: UIView {

    var resultVote = 0
    var onEstimateAction: (() -> Void)?
    var firstStarImageView = UIImageView()
    var secondStarImageView = UIImageView()
    var thirdStarImageView = UIImageView()
    var fourStarImageView = UIImageView()
    var fiveStarImageView = UIImageView()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.grayFont
        label.layer.opacity = 0.88
        label.text = "Оцените качество обслуживания"
        return label
    }()

    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        horizontalStack.addArrangedSubview(firstStarImageView)
        horizontalStack.addArrangedSubview(secondStarImageView)
        horizontalStack.addArrangedSubview(thirdStarImageView)
        horizontalStack.addArrangedSubview(fourStarImageView)
        horizontalStack.addArrangedSubview(fiveStarImageView)
        addSubview(horizontalStack)
        addSubview(separator)
        voteConfig()
    }
    
    func voteConfig(_ resultVote: String? = nil) {
        
        switch resultVote {
        case nil:
            firstStarImageView.image = UIImage(asset: .rateDisableStar)
            secondStarImageView.image = UIImage(asset: .rateDisableStar)
            thirdStarImageView.image = UIImage(asset: .rateDisableStar)
            fourStarImageView.image = UIImage(asset: .rateDisableStar)
            fiveStarImageView.image = UIImage(asset: .rateDisableStar)
        case "1":
            firstStarImageView.image = UIImage(asset: .rateEnableStar)
            secondStarImageView.image = UIImage(asset: .rateDisableStar)
            thirdStarImageView.image = UIImage(asset: .rateDisableStar)
            fourStarImageView.image = UIImage(asset: .rateDisableStar)
            fiveStarImageView.image = UIImage(asset: .rateDisableStar)
        case "2":
            firstStarImageView.image = UIImage(asset: .rateEnableStar)
            secondStarImageView.image = UIImage(asset: .rateEnableStar)
            thirdStarImageView.image = UIImage(asset: .rateDisableStar)
            fourStarImageView.image = UIImage(asset: .rateDisableStar)
            fiveStarImageView.image = UIImage(asset: .rateDisableStar)
        case "3":
            firstStarImageView.image = UIImage(asset: .rateEnableStar)
            secondStarImageView.image = UIImage(asset: .rateEnableStar)
            thirdStarImageView.image = UIImage(asset: .rateEnableStar)
            fourStarImageView.image = UIImage(asset: .rateDisableStar)
            fiveStarImageView.image = UIImage(asset: .rateDisableStar)
        case "4":
            firstStarImageView.image = UIImage(asset: .rateEnableStar)
            secondStarImageView.image = UIImage(asset: .rateEnableStar)
            thirdStarImageView.image = UIImage(asset: .rateEnableStar)
            fourStarImageView.image = UIImage(asset: .rateEnableStar)
            fiveStarImageView.image = UIImage(asset: .rateDisableStar)
        case "5":
            firstStarImageView.image = UIImage(asset: .rateEnableStar)
            secondStarImageView.image = UIImage(asset: .rateEnableStar)
            thirdStarImageView.image = UIImage(asset: .rateEnableStar)
            fourStarImageView.image = UIImage(asset: .rateEnableStar)
            fiveStarImageView.image = UIImage(asset: .rateEnableStar)
        default:
            break
        }
    }
    

    // MARK: - Action



    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        self.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
       
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            horizontalStack.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            horizontalStack.widthAnchor.constraint(equalToConstant: 132)
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
