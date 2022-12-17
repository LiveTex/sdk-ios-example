//
//  Settings.swift
//  LivetexMessaging
//
//  Created by Livetex on 29.06.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

private struct Key {
    static let visitorToken = "com.livetex.visitorToken"
}

class Settings {

    var visitorToken: String? {
        get {
            return UserDefaults.standard.string(forKey: Key.visitorToken)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Key.visitorToken)
        }
    }

}
