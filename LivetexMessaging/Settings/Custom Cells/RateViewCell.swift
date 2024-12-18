//
//  RateViewCell.swift
//
//
//  Created by Yuri on 04.12.2024.
//

import UIKit
import MessageKit
import LivetexCore

class RateViewCell: UICollectionViewCell, UITextViewDelegate {
    
    //MARK: - Public Properties
    
    var action: ((Int?, String?) -> Void)?
    var actionKeyboard: (() -> Void)?
    var commentConstraints: [NSLayoutConstraint] = []
    var beforeTitleConstraints: [NSLayoutConstraint] = []
    var hightStackConstraints: [NSLayoutConstraint] = []
    var afterTitleConstraints: [NSLayoutConstraint] = []
    var horizontalStackConstraints: [NSLayoutConstraint] = []
    var commentFirstTextViewConstraints: [NSLayoutConstraint] = []
    var commentSecondTextViewConstraints: [NSLayoutConstraint] = []
    var buttonConstraints: [NSLayoutConstraint] = []
    
    //MARK: - Private Properties
    
    private var setRate: VoteResult?
    private var hightStack: NSLayoutConstraint?
    private var isResultVote: Bool?
    private var isComment: Bool = true
    private var isTwoPoint: Bool = false
    private var beforTitle: String = ""
    private var afterTitle: String = ""
    private var commentTitle: String? = nil
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.layer.opacity = 0.88
        label.numberOfLines = 0
        return label
    }()
    
    private let afterLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12)
        label.textColor = UIColor.grayFont
        label.layer.opacity = 1
        label.numberOfLines = 0
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 14)
        label.textColor = UIColor.black
        label.layer.opacity = 0.88
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        return label
    }()
    
    private let coverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.grayBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        return view
    }()
  
    var rating: Int? = nil {
        didSet {
            for (index, star) in horizontalStack.arrangedSubviews.enumerated() {
                if !isTwoPoint {
                    (star as? UIImageView)?.image = index < (rating ?? -1) ? UIImage(asset: .rateEnableStar) :  UIImage(asset: .rateDisableStar)
                } else {
                    if rating == 1 && index == 0 {
                        (star as? UIImageView)?.image = UIImage(asset: .voteUpGreen)
                    } else if rating == 0 && index == 1 {
                        (star as? UIImageView)?.image = UIImage(asset: .voteDownRed)
                    } else if rating == index && index == 0 {
                        (star as? UIImageView)?.image = UIImage(asset: .voteUpGray)
                    } else if rating == index && index == 1 {
                        (star as? UIImageView)?.image = UIImage(asset: .voteDownGray)
                    }
                }
            }
            if let rate = rating, rate >= 0 {
                isResultVote = true
            }
        }
    }
    
    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let commentTextView: UITextView = {
        let text = UITextView()
        text.backgroundColor = .white
        text.textAlignment = .left
        text.font = UIFont.systemFont(ofSize: 14)
        text.textColor = UIColor.black
        text.layer.opacity = 0.88
        text.layer.cornerRadius = 6
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.grayButton.cgColor
        text.isScrollEnabled = true //false
        text.textContainerInset = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5) // Здесь 5 поинтов слева
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий (не обязательно)"
        label.font = UIFont.systemFont(ofSize: 14)
        label.sizeToFit()
        label.textColor = UIColor.black
        label.layer.opacity = 0.25
        return label
    }()
    
    
    private let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оценить", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.backgroundColor = UIColor.voteButton
        button.layer.cornerRadius = 6
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        commentTextView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Configuration
    
    func config(isComment: Bool, isTwoPoint: Bool, beforTitle: String, afterTitle: String, setRate: VoteResult? = nil) {
        self.isComment = isComment
        self.beforTitle = beforTitle
        self.afterTitle = afterTitle
        self.isTwoPoint = isTwoPoint
        self.setRate = setRate
        self.titleLabel.text = nil
        self.afterLabel.text = nil
        self.commentTitle = nil
        self.commentLabel.text = nil
        self.commentTextView.text = nil
        rateButton.removeFromSuperview()
        commentTextView.removeFromSuperview()
        titleLabel.removeFromSuperview()
        afterLabel.removeFromSuperview()
        commentLabel.removeFromSuperview()
        
        NSLayoutConstraint.deactivate(commentConstraints)
        NSLayoutConstraint.deactivate(beforeTitleConstraints)
        NSLayoutConstraint.deactivate(hightStackConstraints)
        NSLayoutConstraint.deactivate(afterTitleConstraints)
        NSLayoutConstraint.deactivate(horizontalStackConstraints)
        NSLayoutConstraint.deactivate(buttonConstraints)
        NSLayoutConstraint.deactivate(commentFirstTextViewConstraints)
        NSLayoutConstraint.deactivate(commentSecondTextViewConstraints)
        
        hightStack?.isActive = false

        contentView.addSubview(coverView)
        contentView.backgroundColor = .clear
        coverView.addSubview(horizontalStack)
        for subview in horizontalStack.arrangedSubviews {
            horizontalStack.removeArrangedSubview(subview)
                subview.removeFromSuperview()
            }
        if let setRate = setRate {
            guard let rate = Int(setRate.value) else { return }
            self.commentTitle = setRate.comment ?? ""
            if !isTwoPoint {
                for _ in 0..<rate {
                    let image = UIImageView()
                    image.image = UIImage(asset: .rateEnableStar)
                    image.contentMode = .scaleAspectFill
                    horizontalStack.addArrangedSubview(image)
                }
                horizontalStackConstraints = [
                horizontalStack.widthAnchor.constraint(equalToConstant: CGFloat(((rate * 20) + (8 * (rate - 1)))))]

            } else {
                let imageleft = UIImageView()
                let imageRight = UIImageView()
                
                if rate == 1 {
                    imageleft.image = UIImage(asset: .voteUpGreen)
                    imageleft.contentMode = .scaleAspectFit
                    horizontalStack.addArrangedSubview(imageleft)
                } else {
                    imageRight.image = UIImage(asset: .voteDownRed)
                    imageRight.contentMode = .scaleAspectFit
                    horizontalStack.addArrangedSubview(imageRight)
                }
                horizontalStackConstraints = [
                horizontalStack.widthAnchor.constraint(equalToConstant: 22)
                ]
            }
        } else {
            if !isTwoPoint {
                for _ in 0..<5 {
                    let image = UIImageView()
                    image.image = UIImage(asset: .rateDisableStar)
                    image.contentMode = .scaleAspectFill
                    horizontalStack.addArrangedSubview(image)
                }
                horizontalStackConstraints = [
                horizontalStack.widthAnchor.constraint(equalToConstant: 258)
                ]
            } else {
                let imageleft = UIImageView()
                let imageRight = UIImageView()
                
                imageleft.contentMode = .scaleAspectFit
                imageRight.contentMode = .scaleAspectFit
                
                imageleft.image = UIImage(asset: .voteUpGray)
                imageRight.image = UIImage(asset: .voteDownGray)
                horizontalStack.addArrangedSubview(imageleft)
                horizontalStack.addArrangedSubview(imageRight)
                horizontalStackConstraints = [
                horizontalStack.widthAnchor.constraint(equalToConstant: 152)
                ]
            }
        }
        NSLayoutConstraint.activate(horizontalStackConstraints)

        coverView.addSubview(titleLabel)
        coverView.addSubview(commentLabel)
        commentTextView.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 10, y: commentTextView.textContainerInset.top)
        placeholderLabel.isHidden = !commentTextView.text.isEmpty
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        afterLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            coverView.topAnchor.constraint(equalTo: contentView.topAnchor),
            coverView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            coverView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
        if let setRate = setRate {
            hightStackConstraints = [
            horizontalStack.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 16),
            horizontalStack.heightAnchor.constraint(equalToConstant: 20),
            horizontalStack.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
            ]
            NSLayoutConstraint.activate(hightStackConstraints)
        } else {
            coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)

            if beforTitle.count == 0 {
                hightStackConstraints = [
                    horizontalStack.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 16),
                    horizontalStack.centerXAnchor.constraint(equalTo: coverView.centerXAnchor)
                ]
                NSLayoutConstraint.activate(hightStackConstraints)

            } else {
                titleLabel.text = beforTitle
                beforeTitleConstraints = [
                    titleLabel.topAnchor.constraint(equalTo: coverView.topAnchor, constant: 16),
                    titleLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                    titleLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 16),
                    titleLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -16),
                    titleLabel.bottomAnchor.constraint(equalTo: horizontalStack.topAnchor, constant: -16)
                ]
                NSLayoutConstraint.activate(beforeTitleConstraints)
                
                hightStackConstraints = [
                    horizontalStack.heightAnchor.constraint(equalToConstant: 45),
                    horizontalStack.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                ]
                NSLayoutConstraint.activate(hightStackConstraints)

            }
        }
      
        
     
        if let setRate = setRate {
            commentLabel.text = commentTitle
            if commentTitle?.count == 0 || commentTitle == nil {
                commentConstraints = [
                    horizontalStack.bottomAnchor.constraint(equalTo: coverView.bottomAnchor, constant: -16),
                ]
                NSLayoutConstraint.activate(commentConstraints)
            } else {
                commentConstraints = [
                    
                    commentLabel.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 16),
                    commentLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                    commentLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 16),
                    commentLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -16),
                    commentLabel.bottomAnchor.constraint(equalTo: coverView.bottomAnchor, constant: -16)
                ]
                NSLayoutConstraint.activate(commentConstraints)
            }
            
            if afterTitle.count == 0 {
                hightStack = coverView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)//
                hightStack?.isActive = true
            } else {
                coverView.addSubview(afterLabel)
                
                afterLabel.text = afterTitle
                afterTitleConstraints = [
                    afterLabel.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                    afterLabel.topAnchor.constraint(equalTo: coverView.bottomAnchor, constant: 8),
                    afterLabel.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 16),
                    afterLabel.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -16),
                    afterLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
                ]
                NSLayoutConstraint.activate(afterTitleConstraints)
            }
            
        } else {
            coverView.addSubview(commentTextView)
            coverView.addSubview(rateButton)

            rateButton.addTarget(self, action: #selector(pressButton), for: .touchUpInside)

            commentFirstTextViewConstraints = [
                commentTextView.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                commentTextView.leadingAnchor.constraint(equalTo: coverView.leadingAnchor, constant: 16),
                commentTextView.trailingAnchor.constraint(equalTo: coverView.trailingAnchor, constant: -16),
            ]
            NSLayoutConstraint.activate(commentFirstTextViewConstraints)

            if isComment == true {
                commentSecondTextViewConstraints = [
                commentTextView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 16),
                commentTextView.heightAnchor.constraint(lessThanOrEqualToConstant: 52),
                commentTextView.bottomAnchor.constraint(equalTo: rateButton.topAnchor, constant: -16)
                ]
            } else {
                commentSecondTextViewConstraints = [
                commentTextView.topAnchor.constraint(equalTo: horizontalStack.bottomAnchor, constant: 8),
                commentTextView.heightAnchor.constraint(equalToConstant: 0),
                commentTextView.bottomAnchor.constraint(equalTo: rateButton.topAnchor, constant: -8)
                ]
            }
            NSLayoutConstraint.activate(commentSecondTextViewConstraints)
            buttonConstraints = [
                rateButton.centerXAnchor.constraint(equalTo: coverView.centerXAnchor),
                rateButton.widthAnchor.constraint(equalToConstant: 92),
                rateButton.heightAnchor.constraint(equalToConstant: 32),
                coverView.bottomAnchor.constraint(equalTo: rateButton.bottomAnchor, constant: 16)
            ]
            NSLayoutConstraint.activate(buttonConstraints)
        }
        
        if isResultVote == nil {
            disableButton()
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        horizontalStack.addGestureRecognizer(tapGesture)
    }
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        placeholderLabel.isHidden = !textView.text.isEmpty
        actionKeyboard?()
    }
    
    // MARK: - Action
    
    @objc private func handleTap(_ gesture: UITapGestureRecognizer) {
        if setRate == nil {
            if self.isTwoPoint {
                let point = gesture.location(in: horizontalStack)
                if point.x < 76 {
                    rating = 1
                } else {
                    rating = 0
                }
            } else {
                let point = gesture.location(in: horizontalStack)
                rating = Int(point.x / (258 / 5)) + 1
            }
            activeButton()
        }
    }
    
    @objc private func pressButton() {
        action?(rating, commentTextView.text)
        disableButton()
    }
    
    func activeButton() {
        rateButton.isEnabled = true
        rateButton.setTitleColor(UIColor.white, for: .normal)
        rateButton.backgroundColor = UIColor.voteButton
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.voteButton.cgColor
    }
    
    func disableButton() {
        rateButton.isEnabled = false
        rateButton.setTitleColor(UIColor(red: 0, green: 0, blue: 0, alpha: 0.25), for: .normal)
        rateButton.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.04)
        rateButton.layer.borderWidth = 1
        rateButton.layer.borderColor = UIColor.grayButton.cgColor
    }
}
