//
//  SystemMessageCollectionViewCell.swift
//  LivetexMessaging
//
//  Created by Livetex on 14.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit

class SystemMessageCollectionViewCell: UICollectionViewCell {

    private let textLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        textLabel.text = nil
    }

    // MARK: - Layout

    override func layoutSubviews() {
        super.layoutSubviews()

        textLabel.frame = CGRect(origin: .zero, size: contentView.bounds.size)
    }

    // MARK: - Configuration

    func configure(with message: MessageType, at indexPath: IndexPath, and messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .custom(let data):
            guard case let .system(text) = data as? CustomType else {
                return
            }
            textLabel.text = text
        default:
            break
        }
    }
    
}
