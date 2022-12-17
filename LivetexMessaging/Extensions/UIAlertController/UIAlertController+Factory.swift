//
//  UIAlertController+Factory.swift
//  LivetexMessaging
//
//  Created by Livetex on 06.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

extension UIAlertController {

    func addActions(_ actions: [UIAlertAction]) {
        actions.forEach { addAction($0) }
    }

    func addActions(_ actions: UIAlertAction...) {
        addActions(actions)
    }

}
