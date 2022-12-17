//
//  UIImage+Asset.swift
//  LivetexMessaging
//
//  Created by Livetex on 30.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

extension UIImage {

    convenience init?(asset: Asset) {
        self.init(named: asset.rawValue)
    }

}
