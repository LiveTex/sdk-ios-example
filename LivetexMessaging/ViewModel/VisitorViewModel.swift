//
//  VisitorViewModel.swift
//  LivetexMessaging
//
//  Created by Iurii Kotikhin on 01.06.2023.
//  Copyright © 2023 Livetex. All rights reserved.
//

import UIKit
import LivetexCore

class VisitorViewModel {

    // MARK: - Public properties

    let completionHandler: ((SessionToken) -> Void)
    var action: (() -> Void)?

    //MARK: - Initialization

    init (completionHandler: @escaping ((SessionToken) -> Void)) {
        self.completionHandler = completionHandler
    }

    //MARK: - Public Methods
    
    func requestAuthenticationTwoTokens(deviceToken: String, customToken: String) {
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, customVisitorToken: customToken, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(infoSession):
                    self?.completionHandler(infoSession)
                    self?.action?()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func requestAuthenticationEmptyTokens(deviceToken: String) {
        let loginService = LivetexAuthService(deviceToken: deviceToken)
        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(infoSession):
                    self?.action?()
                    self?.completionHandler(infoSession)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func requestAuthenticationVisitorToken(deviceToken: String) {
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(infoSession):
                    self?.completionHandler(infoSession)
                    self?.action?()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func requestAuthenticationCustomToken(deviceToken: String, customToken: String) {
        let loginService = LivetexAuthService(customVisitorToken: customToken, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(infoSession):
                    self?.completionHandler(infoSession)
                    self?.action?()
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
