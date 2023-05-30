//
//  VisitorViewController.swift
//  LivetexMessaging
//
//  Created by Iurii Kotikhin on 22.05.2023.
//  Copyright © 2023 Livetex. All rights reserved.
//

import UIKit
import LivetexCore

class VisitorViewController: UIViewController {

    let currentTokenLabel = UILabel()
    let customVisitorTokenLabel = UILabel()
    let customVisitorTokenTextField = UITextField()

    let sendCurrentVisitorTokenButton = UIButton()
    let sendEmptyTokenButton = UIButton()
    let sendCustomTokenButton = UIButton()
    let sendTwoTokenButton = UIButton()

    let currentAccessKeyLabel = UILabel()
    let changeAccessKeyLabel = UILabel()
    let changeAccessKeyTextField = UITextField()


    private let settings = Settings()
    var deviceToken: String? =  nil
    private var keychainItem: CFDictionary? = nil
    private var ref: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        addAction()
        setData()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func setUI() {
        view.addSubview(currentTokenLabel)
        currentTokenLabel.numberOfLines = 2
        currentTokenLabel.text = "Текущий токен (visitorToken):"
        currentTokenLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            currentTokenLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            currentTokenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentTokenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

        ])

        view.addSubview(customVisitorTokenLabel)
        customVisitorTokenLabel.translatesAutoresizingMaskIntoConstraints = false
        customVisitorTokenLabel.textAlignment = .left
        customVisitorTokenLabel.text = "customVisitorToken:"
        NSLayoutConstraint.activate([
            customVisitorTokenLabel.heightAnchor.constraint(equalToConstant: 20),
            customVisitorTokenLabel.topAnchor.constraint(equalTo: currentTokenLabel.bottomAnchor, constant: 10),
            customVisitorTokenLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customVisitorTokenLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])


        view.addSubview(customVisitorTokenTextField)
        customVisitorTokenTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customVisitorTokenTextField.heightAnchor.constraint(equalToConstant: 40),
            customVisitorTokenTextField.topAnchor.constraint(equalTo: customVisitorTokenLabel.bottomAnchor, constant: 10),
            customVisitorTokenTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            customVisitorTokenTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        customVisitorTokenTextField.placeholder = " customVisitorToken"
        customVisitorTokenTextField.layer.borderWidth = 1
        customVisitorTokenTextField.layer.borderColor = UIColor.gray.cgColor
        customVisitorTokenTextField.layer.cornerRadius = 8
        customVisitorTokenTextField.backgroundColor = .systemGray6

        view.addSubview(sendEmptyTokenButton)
        sendEmptyTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendEmptyTokenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            sendEmptyTokenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            sendEmptyTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendEmptyTokenButton.topAnchor.constraint(equalTo: customVisitorTokenTextField.bottomAnchor, constant: 20),
        ])
        sendEmptyTokenButton.setTitle("Авторизоваться с новым visitorToken", for: .normal)
        sendEmptyTokenButton.backgroundColor = UIColor.buttonToken
        sendEmptyTokenButton.layer.cornerRadius = 8
        sendEmptyTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)


        view.addSubview(sendCurrentVisitorTokenButton)
        sendCurrentVisitorTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendCurrentVisitorTokenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            sendCurrentVisitorTokenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            sendCurrentVisitorTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendCurrentVisitorTokenButton.topAnchor.constraint(equalTo: sendEmptyTokenButton.bottomAnchor, constant: 10),
        ])
        sendCurrentVisitorTokenButton.setTitle("Авторизоваться только с текущим \n visitorToken", for: .normal)
        sendCurrentVisitorTokenButton.backgroundColor = UIColor.buttonToken
        sendCurrentVisitorTokenButton.layer.cornerRadius = 8
        sendCurrentVisitorTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        sendCurrentVisitorTokenButton.titleLabel?.numberOfLines = 2
        sendCurrentVisitorTokenButton.titleLabel?.textAlignment = .center

        view.addSubview(sendCustomTokenButton)
        sendCustomTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendCustomTokenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            sendCustomTokenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            sendCustomTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendCustomTokenButton.topAnchor.constraint(equalTo: sendCurrentVisitorTokenButton.bottomAnchor, constant: 10),
        ])

        sendCustomTokenButton.setTitle("Авторизоваться только с указанным \n customVisitorToken", for: .normal)
        sendCustomTokenButton.backgroundColor = UIColor.buttonToken
        sendCustomTokenButton.layer.cornerRadius = 8
        sendCustomTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        sendCustomTokenButton.titleLabel?.numberOfLines = 2
        sendCustomTokenButton.titleLabel?.textAlignment = .center


        view.addSubview(sendTwoTokenButton)
        sendTwoTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendTwoTokenButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            sendTwoTokenButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            sendTwoTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendTwoTokenButton.topAnchor.constraint(equalTo: sendCustomTokenButton.bottomAnchor, constant: 10),
        ])
        sendTwoTokenButton.setTitle("Авторизоваться с указанным \n customVisitorToken и текущим visitorToken", for: .normal)
        sendTwoTokenButton.backgroundColor = UIColor.buttonToken
        sendTwoTokenButton.layer.cornerRadius = 8
        sendTwoTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 13.0)
        sendTwoTokenButton.titleLabel?.numberOfLines = 2
        sendTwoTokenButton.titleLabel?.textAlignment = .center

        view.addSubview(currentAccessKeyLabel)
        currentAccessKeyLabel.translatesAutoresizingMaskIntoConstraints = false
        currentAccessKeyLabel.numberOfLines = 3
        currentAccessKeyLabel.text = "Текущий ключ доступа (LivetexAppId):"
        NSLayoutConstraint.activate([
            currentAccessKeyLabel.topAnchor.constraint(equalTo: sendTwoTokenButton.bottomAnchor, constant: 30),
            currentAccessKeyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            currentAccessKeyLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])

        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutside)
    }

    func addAction() {
        sendTwoTokenButton.addTarget(self, action: #selector(sendTwoTokens), for: .touchUpInside)
        sendEmptyTokenButton.addTarget(self, action: #selector(sendEmptyTokens ), for: .touchUpInside)
        sendCurrentVisitorTokenButton.addTarget(self, action: #selector(sendVisitorToken), for: .touchUpInside)
        sendCustomTokenButton.addTarget(self, action: #selector(sendCustomToken), for: .touchUpInside)

    }

    @objc func sendTwoTokens() {
        guard let deviceToken = deviceToken else { return }
        self.requestAuthenticationTwoTokens(deviceToken: deviceToken )
    }

    @objc func sendEmptyTokens() {
        guard let deviceToken = deviceToken else { return }
        self.requestAuthenticationEmptyTokens(deviceToken: deviceToken)
    }

    @objc func sendVisitorToken() {
        guard let deviceToken = deviceToken else { return }
        self.requestAuthenticationVisitorToken(deviceToken: deviceToken )
    }

    @objc func sendCustomToken() {
        guard let deviceToken = deviceToken else { return }
        self.requestAuthenticationCustomToken(deviceToken: deviceToken)
    }


    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    func setData() {
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken"),
        let textVisitorToken = currentTokenLabel.text,
        let livetexInfo = Bundle.main.infoDictionary?["Livetex"] as? [String: String],
        let accessKey = livetexInfo["LivetexAppID"],
        let textCurrentKey = currentAccessKeyLabel.text else { return }
        currentTokenLabel.text = textVisitorToken + "\n" + visitorToken
        currentAccessKeyLabel.text = textCurrentKey + "\n" + accessKey
        print(accessKey)
    }

    private func requestAuthenticationTwoTokens(deviceToken: String) {
        let customTokenText = customVisitorTokenTextField.text ?? "TestCustomToken"
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, customVisitorToken: customTokenText, deviceToken: deviceToken)

        loginService.requestAuthorization { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationEmptyTokens(deviceToken: String) {
        let loginService = LivetexAuthService(deviceToken: deviceToken)
        loginService.requestAuthorization { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                   break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationVisitorToken(deviceToken: String) {
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, deviceToken: deviceToken)

        loginService.requestAuthorization { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationCustomToken(deviceToken: String) {
        let customToken = customVisitorTokenTextField.text ?? "TestCustomToken"
        let loginService = LivetexAuthService(customVisitorToken: customToken, deviceToken: deviceToken)

        loginService.requestAuthorization { result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    break
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
