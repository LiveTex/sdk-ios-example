//
//  Button+Action.swift
//  LivetexMessaging
//
//  Created by Iurii Kotikhin on 10/31/23.
//  Copyright © 2023 Livetex. All rights reserved.
//

import UIKit


extension UIButton {
    func buttonTapped() {
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: 0.1, animations: {
                self?.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }, completion: { _ in
                UIView.animate(withDuration: 0.1, animations: {
                    self?.transform = CGAffineTransform.identity
                })
            })
        }
    }
}
