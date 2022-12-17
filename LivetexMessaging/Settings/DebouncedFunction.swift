//
//  DebouncedFunction.swift
//  LivetexMessaging
//
//  Created by LiveTex on 01.03.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit

final class DebouncedFunction {

    var isValid: Bool {
        return timer?.isValid ?? false
    }

    private let timeInterval: TimeInterval
    private let action: () -> Void

    private var timer: Timer?

    // MARK: - Initialization

    init(timeInterval: TimeInterval = 0.5, action: @escaping () -> Void) {
        self.timeInterval = timeInterval
        self.action = action
    }

    deinit {
        cancel()
    }

    // MARK: - Action

    func call() {
        cancel()
        let timer = Timer(timeInterval: timeInterval,
                          target: self,
                          selector: #selector(onTimerFired),
                          userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
        self.timer = timer
    }

    func fire() {
        cancel()
        action()
    }

    func cancel() {
        timer?.invalidate()
        timer = nil
    }

    @objc private func onTimerFired() {
        action()
    }
}
