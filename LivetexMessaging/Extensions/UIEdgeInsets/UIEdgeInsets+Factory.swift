//
//  UIEdgeInsets+Factory.swift
//  LivetexMessaging
//
//  Created by Livetex on 07.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

extension UIEdgeInsets {

    var horizontal: CGFloat {
        return left + right
    }

    var vertical: CGFloat {
        return top + bottom
    }

}
