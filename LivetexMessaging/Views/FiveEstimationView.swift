//
//  FiveEstimationView.swift
//  LivetexMessaging
//
//  Created by Yuri on 19.09.2024.
//  Copyright © 2024 Livetex. All rights reserved.
//

import UIKit

class FiveEstimationView: UIView {

    var isResultVote: Bool?
    var onFiveEstimateAction: ((Int) -> Void)?

    var firstStarImageView = UIImageView()
    var secondStarImageView = UIImageView()
    var thirdStarImageView = UIImageView()
    var fourStarImageView = UIImageView()
    var fiveStarImageView = UIImageView()
    var rating: Int = 0 {
        didSet {
            for (index, star) in horizontalStack.arrangedSubviews.enumerated() {
                (star as? UIImageView)?.image = index < rating ? UIImage(asset: .rateEnableStar) :  UIImage(asset: .rateDisableStar)
            }
        }
    }
    
    private lazy var voteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оценить", for: .normal)
        button.addTarget(self, action: #selector(onButtonTappedVote), for: .touchUpInside)
        button.layer.cornerRadius = 8
        return button
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
        horizontalStack.addArrangedSubview(firstStarImageView)
        horizontalStack.addArrangedSubview(secondStarImageView)
        horizontalStack.addArrangedSubview(thirdStarImageView)
        horizontalStack.addArrangedSubview(fourStarImageView)
        horizontalStack.addArrangedSubview(fiveStarImageView)
        for (index, star) in horizontalStack.arrangedSubviews.enumerated() {
            (star as? UIImageView)?.image = UIImage(asset: .rateDisableStar)
        }
        addSubview(horizontalStack)
        addSubview(separator)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        horizontalStack.addGestureRecognizer(tapGesture)
    }
    
    
    
    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(voteButton)
        
        voteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.heightAnchor.constraint(equalToConstant: 45),
            horizontalStack.widthAnchor.constraint(equalToConstant: 258),
            horizontalStack.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            horizontalStack.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            voteButton.heightAnchor.constraint(equalToConstant: 32),
            voteButton.widthAnchor.constraint(equalToConstant: 92),
            voteButton.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 24),
            voteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -24),
            voteButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        if isResultVote == nil {
            disableButton()
        }
    }
    
    // MARK: - Action
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: horizontalStack)
        rating = Int(point.x / (258 / 5)) + 1
        activeButton()
    }
    
    @objc private func onButtonTappedVote() {
        if rating != 0 {
            onFiveEstimateAction?(rating)
        }
    }
    func disableButton() {
        voteButton.isEnabled = false
        voteButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25), for: .normal)
        voteButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04)
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = UIColor.grayButton.cgColor
    }
    func resetResult() {
        rating = 0
        disableButton()
    }
    
    func activeButton() {
        voteButton.isEnabled = true
        voteButton.setTitleColor(UIColor.white, for: .normal)
        voteButton.backgroundColor = UIColor.voteButton
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = UIColor.voteButton.cgColor
    }

    static var viewHeight: CGFloat {
        return 149
    }
}
