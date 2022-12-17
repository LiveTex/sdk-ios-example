//
//  UIResponder+First.swift
//  LivetexMessaging
//
//  Created by Nikita Fomichev on 01.11.2021.
//  Copyright © 2021 Livetex. All rights reserved.
//

import UIKit

private var _foundFirstResponder: UIResponder? = nil

extension UIResponder {

    static var first: UIResponder? {

        // Sending an action to 'nil' implicitly sends it to the first responder
        // where we simply capture it and place it in the _foundFirstResponder variable.
        // As such, the variable will contain the current first responder (if any) immediately after this line executes
        UIApplication.shared.sendAction(#selector(UIResponder.storeFirstResponder(_:)), to: nil, from: nil, for: nil)

        // The following 'defer' statement runs *after* this getter returns,
        // thus releasing any strong reference held by the variable immediately thereafter
        defer {
            _foundFirstResponder = nil
        }

        // Return the found first-responder (if any) back to the caller
        return _foundFirstResponder
    }

    @objc func storeFirstResponder(_ sender: AnyObject) {

        // Capture the recipient of this message (self), which is the first responder
        _foundFirstResponder = self
    }
}
