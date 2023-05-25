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

    let inputTextField = UITextField()
    let sendTwoTokenButton = UIButton()
    let sendVisitorTokenButton = UIButton()
    let sendCustomTokenButton = UIButton()
    let sendEmptyTokenButton = UIButton()
    let outputLabel = UILabel()

    private let settings = Settings()
    var deviceToken: String? =  nil
    private var keychainItem: CFDictionary? = nil
    private var ref: AnyObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUI()
        addAction()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

    func setUI() {
        view.addSubview(inputTextField)
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputTextField.heightAnchor.constraint(equalToConstant: 40),
            inputTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            inputTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            inputTextField.widthAnchor.constraint(equalToConstant: 240)])

        inputTextField.placeholder = " Custom Token"
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.gray.cgColor
        inputTextField.layer.cornerRadius = 8
        inputTextField.backgroundColor = .systemGray6

        view.addSubview(sendTwoTokenButton)
        sendTwoTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendTwoTokenButton.widthAnchor.constraint(equalToConstant: 150),
            sendTwoTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendTwoTokenButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 30),
            sendTwoTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 90)
        ])
        sendTwoTokenButton.setTitle("Send Two Token", for: .normal)
        sendTwoTokenButton.backgroundColor = .black
        sendTwoTokenButton.layer.cornerRadius = 8
        sendTwoTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)

        view.addSubview(sendEmptyTokenButton)
        sendEmptyTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendEmptyTokenButton.widthAnchor.constraint(equalToConstant: 150),
            sendEmptyTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendEmptyTokenButton.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 30),
            sendEmptyTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -90)
        ])
        sendEmptyTokenButton.setTitle("Send Empty Tokens", for: .normal)
        sendEmptyTokenButton.backgroundColor = .black
        sendEmptyTokenButton.layer.cornerRadius = 8
        sendEmptyTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)


        view.addSubview(sendVisitorTokenButton)
        sendVisitorTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendVisitorTokenButton.widthAnchor.constraint(equalToConstant: 150),
            sendVisitorTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendVisitorTokenButton.topAnchor.constraint(equalTo: sendTwoTokenButton.bottomAnchor, constant: 20),
            sendVisitorTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: 90)
        ])
        sendVisitorTokenButton.setTitle("Send Visitor Token", for: .normal)
        sendVisitorTokenButton.backgroundColor = .black
        sendVisitorTokenButton.layer.cornerRadius = 8
        sendVisitorTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)


        view.addSubview(sendCustomTokenButton)
        sendCustomTokenButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendCustomTokenButton.widthAnchor.constraint(equalToConstant: 150),
            sendCustomTokenButton.heightAnchor.constraint(equalToConstant: 54),
            sendCustomTokenButton.topAnchor.constraint(equalTo: sendTwoTokenButton.bottomAnchor, constant: 20),
            sendCustomTokenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor,constant: -90)
        ])
        sendCustomTokenButton.setTitle("Send Custom Token", for: .normal)
        sendCustomTokenButton.backgroundColor = .black
        sendCustomTokenButton.layer.cornerRadius = 8
        sendCustomTokenButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)

        view.addSubview(outputLabel)
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outputLabel.heightAnchor.constraint(equalToConstant: 290),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputLabel.topAnchor.constraint(equalTo: sendCustomTokenButton.bottomAnchor, constant: 30)])
        outputLabel.layer.cornerRadius = 8
        outputLabel.layer.borderWidth = 1
        outputLabel.layer.borderColor = UIColor.gray.cgColor
        outputLabel.backgroundColor = .systemGray6
        outputLabel.numberOfLines = 0

        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutside)
    }

    func addAction() {
        sendTwoTokenButton.addTarget(self, action: #selector(sendTwoTokens), for: .touchUpInside)
        sendEmptyTokenButton.addTarget(self, action: #selector(sendEmptyTokens ), for: .touchUpInside)
        sendVisitorTokenButton.addTarget(self, action: #selector(sendVisitorToken), for: .touchUpInside)
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

    private func requestAuthenticationTwoTokens(deviceToken: String) {
        let customTokenText = inputTextField.text ?? "TestCustomToken"
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, customVisitorToken: customTokenText, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.outputLabel.text =
                    "Посылаемые токены: " + "\n" +
                    "customToken: " +  customTokenText + "\n" +
                    "visiterToken: " + visitorToken + "\n" + "\n" +
                    "Ответ от сервера:" + "\n" +
                    "visitorToken:  " + token.visitorToken + "\n" +
                    "upload:  " + token.endpoints.upload + "\n" +
                    "ws:  " + token.endpoints.ws
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationEmptyTokens(deviceToken: String) {
        let loginService = LivetexAuthService(deviceToken: deviceToken)
        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.outputLabel.text =
                    "Посылаемые токены: " + "\n" +
                    "customToken: " +  "Отсутствует" + "\n" +
                    "visiterToken: " + "Отсутствует" + "\n" + "\n" +
                    "Ответ от сервера:" + "\n" +
                    "visitorToken:  " + token.visitorToken + "\n" +
                    "upload:  " + token.endpoints.upload + "\n" +
                    "ws:  " + token.endpoints.ws
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationVisitorToken(deviceToken: String) {
        guard let visitorToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        let loginService = LivetexAuthService(visitorToken: visitorToken, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.outputLabel.text =
                    "Посылаемые токены: " + "\n" +
                    "customToken: " +  "Отсутствует" + "\n" +
                    "visiterToken: " + visitorToken + "\n" + "\n" +
                    "Ответ от сервера:" + "\n" +
                    "visitorToken:  " + token.visitorToken + "\n" +
                    "upload:  " + token.endpoints.upload + "\n" +
                    "ws:  " + token.endpoints.ws
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    private func requestAuthenticationCustomToken(deviceToken: String) {
        let customToken = inputTextField.text ?? "TestCustomToken"
        let loginService = LivetexAuthService(customVisitorToken: customToken, deviceToken: deviceToken)

        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.outputLabel.text =
                    "Посылаемые токены: " + "\n" +
                    "customToken: " + customToken + "\n" +
                    "visiterToken: " + "Отсутствует" + "\n" + "\n" +
                    "Ответ от сервера:" + "\n" +
                    "visitorToken:  " + token.visitorToken + "\n" +
                    "upload:  " + token.endpoints.upload + "\n" +
                    "ws:  " + token.endpoints.ws
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

}
