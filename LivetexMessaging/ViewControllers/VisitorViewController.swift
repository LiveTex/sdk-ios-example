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
    let sendCustomToken = UIButton()
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

        inputTextField.placeholder = "Custom Token"
        inputTextField.layer.borderWidth = 1
        inputTextField.layer.borderColor = UIColor.gray.cgColor
        inputTextField.layer.cornerRadius = 8
        inputTextField.backgroundColor = .systemGray6

        view.addSubview(sendCustomToken)
        sendCustomToken.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendCustomToken.widthAnchor.constraint(equalToConstant: 180),
            sendCustomToken.heightAnchor.constraint(equalToConstant: 54),
            sendCustomToken.topAnchor.constraint(equalTo: inputTextField.bottomAnchor, constant: 30),
            sendCustomToken.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        sendCustomToken.setTitle("Send Custom Token", for: .normal)
        sendCustomToken.backgroundColor = .black
        sendCustomToken.layer.cornerRadius = 8

        view.addSubview(outputLabel)
        outputLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            outputLabel.heightAnchor.constraint(equalToConstant: 290),
            outputLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            outputLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            outputLabel.topAnchor.constraint(equalTo: sendCustomToken.bottomAnchor, constant: 50)])
        outputLabel.layer.cornerRadius = 8
        outputLabel.layer.borderWidth = 1
        outputLabel.layer.borderColor = UIColor.gray.cgColor
        outputLabel.backgroundColor = .systemGray6
        outputLabel.numberOfLines = 0

        let tapOutside: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tapOutside)
    }

    func addAction() {
        sendCustomToken.addTarget(self, action: #selector(sendToken), for: .touchUpInside)
    }

    @objc func sendToken() {
        guard let deviceToken = deviceToken else { return }

        self.requestAuthentication(deviceToken: deviceToken )
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

    private func requestAuthentication(deviceToken: String) {
        var customToken: Token = .custom(inputTextField.text ?? "TestCustomToken")
        let loginService = LivetexAuthService(token: customToken, deviceToken: deviceToken)
        let customTokenText = inputTextField.text ?? "TestCustomToken"
        guard let visiterToken = UserDefaults.standard.string(forKey: "com.livetex.visitorToken") else { return }
        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.outputLabel.text =
                    "Посылаемые токены: " + "\n" +
                    "customToken: " +  customTokenText + "\n" +
                    "visiterToken: " + visiterToken + "\n" + "\n" +
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
