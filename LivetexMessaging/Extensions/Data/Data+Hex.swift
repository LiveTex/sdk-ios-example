//
//  Data+Hex.swift
//  LivetexMessaging
//
//  Created by Livetex on 02.07.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

extension Data {

    var hexString: String {
        return map { String(format: "%02x", $0) }.joined()
    }

}
