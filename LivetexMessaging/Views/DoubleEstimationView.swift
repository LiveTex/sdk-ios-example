//
//  DoubleEstimationView.swift
//  LivetexMessaging
//
//  Created by Yuri on 18.09.2024.
//  Copyright © 2024 Livetex. All rights reserved.
//

import UIKit

class DoubleEstimationView: UIView {

    var resultVote: String?
    var onDoubleEstimateAction: ((String) -> Void)?

    private lazy var voteUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(asset: .voteUpGray), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onButtonTappedUp), for: .touchUpInside)
        return button
    }()

    private lazy var voteDownButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(asset: .voteDownGray), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitle(nil, for: .normal)
        button.addTarget(self, action: #selector(onButtonTappedDown), for: .touchUpInside)
        return button
    }()
    
    private lazy var voteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Оценить", for: .normal)
        button.addTarget(self, action: #selector(onButtonTappedVote), for: .touchUpInside)
        button.layer.cornerRadius = 8
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
        addSubview(voteUpButton)
        addSubview(voteDownButton)
        addSubview(separator)
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.addSubview(voteUpButton)
        self.addSubview(voteDownButton)
        self.addSubview(voteButton)
        
        voteUpButton.translatesAutoresizingMaskIntoConstraints = false
        voteDownButton.translatesAutoresizingMaskIntoConstraints = false
        voteButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            voteUpButton.heightAnchor.constraint(equalToConstant: 45),
            voteUpButton.widthAnchor.constraint(equalToConstant: 50),
            voteUpButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            voteUpButton.trailingAnchor.constraint(equalTo: centerXAnchor, constant: -26)
        ])
        
        NSLayoutConstraint.activate([
            voteDownButton.heightAnchor.constraint(equalToConstant: 45),
            voteDownButton.widthAnchor.constraint(equalToConstant: 50),
            voteDownButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            voteDownButton.leadingAnchor.constraint(equalTo: centerXAnchor, constant: 26)
        ])
        
        NSLayoutConstraint.activate([
            voteButton.heightAnchor.constraint(equalToConstant: 32),
            voteButton.widthAnchor.constraint(equalToConstant: 92),
            voteButton.topAnchor.constraint(equalTo: voteDownButton.bottomAnchor, constant: 26),
            voteButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -26),
            voteButton.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        if resultVote == nil {
            disableButton()
        }
    }
    
    // MARK: - Action

    @objc private func onButtonTappedUp() {
        voteUpButton.setBackgroundImage(UIImage(asset: .voteUpGreen), for: .normal)
        voteDownButton.setBackgroundImage(UIImage(asset: .voteDownGray), for: .normal)

        resultVote = "1"
        voteButton.isEnabled = true
        activeButton()
    }
    
    @objc private func onButtonTappedDown() {
        voteDownButton.setBackgroundImage(UIImage(asset: .voteDownRed), for: .normal)
        voteUpButton.setBackgroundImage(UIImage(asset: .voteUpGray), for: .normal)

        resultVote = "0"
        voteButton.isEnabled = true
        activeButton()
    }
    
    @objc private func onButtonTappedVote() {
        if let resultVote = resultVote {
            onDoubleEstimateAction?(resultVote)
        }
    }
    
    private func disableButton() {
        voteButton.isEnabled = false
        voteButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25), for: .normal)
        voteButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04)
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = UIColor.grayButton.cgColor
    }
    
    func resetResult() {
        voteDownButton.setBackgroundImage(UIImage(asset: .voteDownGray), for: .normal)
        voteUpButton.setBackgroundImage(UIImage(asset: .voteUpGray), for: .normal)
        disableButton()
    }
    
    func activeButton() {
        voteButton.setTitleColor(UIColor.white, for: .normal)
        voteButton.backgroundColor = UIColor.voteButton
        voteButton.layer.borderWidth = 1
        voteButton.layer.borderColor = UIColor.voteButton.cgColor
    }

    static var viewHeight: CGFloat {
        return 149
    }
}
