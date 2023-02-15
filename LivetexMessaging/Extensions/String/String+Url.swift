//
//  String+Url.swift
//  LivetexMessaging
//
//  Created by Paul N on 09.02.2023.
//  Copyright © 2023 Livetex. All rights reserved.
//

import Foundation

extension String {
    
    var isImageUrl: Bool {
        let extensions: Set<String> = ["png", "jpg", "jpeg", "gif"]
        return extensions.contains((self as NSString).pathExtension)
    }
}
