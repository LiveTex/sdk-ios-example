//
//  ChatViewModel.swift
//  LivetexMessaging
//
//  Created by Livetex on 19.05.2020.
//  Copyright © 2022 Livetex. All rights reserved.
//

import UIKit
import MessageKit
import LivetexCore


class ChatViewModel {

    var onDepartmentReceived: (([Department]) -> Void)?
    var onLoadMoreMessages: (([ChatMessage]) -> Void)?
    var onMessagesReceived: (([ChatMessage]) -> Void)?
    var onMessageUpdated: ((Int) -> Void)?
    var onDialogStateReceived: ((Conversation) -> Void)?
    var onAttributesReceived: (() -> Void)?
    var onTypingReceived: (() -> Void)?
    var onWebsocketStateChanged: ((Bool) -> Void)?
    var deviceToken: String?
    var followMessage: String?
    var messages: [ChatMessage] = []
    var sessionToken: SessionToken?

    var user = Recipient(senderId: UUID().uuidString, displayName: "")

    private(set) var sessionService: LivetexSessionService?

    private let loadMoreOffset = 20

    private(set) var isContentLoaded = false
    private(set) var isLoadingMore = false

    private var isCanLoadMore = true

    private(set) var isEmployeeEstimated = true

    private let settings = Settings()

    // MARK: - Initialization

    init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidEnterBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationDidRegisterForRemoteNotifications(_:)),
                                               name: UIApplication.didRegisterForRemoteNotifications,
                                               object: nil)
    }

    // MARK: - Configuration

    private func requestAuthentication(deviceToken: String) {
        let loginService = LivetexAuthService(visitorToken: settings.visitorToken,
                                              deviceToken: deviceToken)
        self.deviceToken = deviceToken
        loginService.requestAuthorization { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(token):
                    self?.sessionToken = token
                    self?.startSession(token: token)
                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func startSession(token: SessionToken) {
        settings.visitorToken = token.visitorToken
        sessionService = LivetexSessionService(token: token)
        sessionService?.onEvent = { [weak self] event in
            self?.didReceive(event: event)
        }
        sessionService?.onConnect = { [weak self] in
            self?.onWebsocketStateChanged?(true)
        }

        sessionService?.onDisconnect = { [weak self] in
            self?.onWebsocketStateChanged?(false)
        }

        sessionService?.connect()
    }

    func loadMoreMessagesIfNeeded() {
        guard isCanLoadMore, let id = messages.first?.messageId, !id.isEmpty else {
            return
        }

        let event = ClientEvent(.getHistory(id, loadMoreOffset))
        sessionService?.sendEvent(event)
        isLoadingMore = true
    }

    // MARK: - Application Lifecycle

    @objc private func applicationDidEnterBackground() {
        sessionService?.disconnect()
    }

    @objc private func applicationWillEnterForeground() {
        sessionService?.connect()
    }

    @objc private func applicationDidRegisterForRemoteNotifications(_ notification: Notification) {
        let deviceToken = notification.object as? String
        requestAuthentication(deviceToken: deviceToken ?? "")
    }

    // MARK: - Session

    func sendEvent(_ event: ClientEvent) {
        let isConnected = sessionService?.isConnected ?? false
        if !isConnected {
            sessionService?.connect()
        }

        sessionService?.sendEvent(event)

        updateMessageIfNeeded(event: event)
    }

    private func didReceive(event: ServiceEvent) {
        switch event {
        case let .result(result):
            print(result)
        case let .state(result):
            isEmployeeEstimated = result.isEmployeeEstimated
            onDialogStateReceived?(result)
        case .attributes:
            onAttributesReceived?()
        case let .departments(result):
            onDepartmentReceived?(result.departments)
        case let .update(result):
            messageHistoryReceived(items: result.messages)
        case .employeeTyping:
            onTypingReceived?()
        @unknown default:
            break
        }
    }

    private func updateMessageIfNeeded(event: ClientEvent) {
        guard case .buttonPressed = event.content,
              let index = messages.lastIndex(where: { $0.keyboard != nil }),
              !messages.isEmpty, let keyboard = messages[index].keyboard else {
            return
        }

        var message = messages[index]
        message.keyboard = Keyboard(buttons: keyboard.buttons, pressed: true)
        messages.remove(at: index)
        messages.insert(message, at: index)

        onMessageUpdated?(index)
    }

    func isPreviousMessageSameDate(at index: Int) -> Bool {
        guard index - 1 >= 0 else {
            return false
        }

        let currentDate = messages[index].sentDate
        let previousDate = messages[index - 1].sentDate
        return Calendar.current.isDate(currentDate, inSameDayAs: previousDate)
    }

    private func convertMessages(_ messages: [Message]) -> [ChatMessage] {
        return messages.map {
            let kind: MessageKind
            let sender = $0.creator.isVisitor ? self.user : Recipient(senderId: "",
                                                                      displayName: $0.creator.employee?.name ?? "")
            switch $0.content {
            case let .text(text):
                if text.isImageUrl {
                    kind = .photo(File(url: text))
                } else if text.first == ">" {
                    let texts = text.trimmingCharacters(in: CharacterSet(charactersIn: "> ")).split(separator: "\n")
                    kind = .custom(CustomType.follow(String(texts.first ?? ""), String(texts.last ?? "")))
                } else {
                    kind = $0.creator.type == .system ? .custom(CustomType.system(text)) : .text(text)
                }
            case let .file(attachment):
                if attachment.url.isImageUrl {
                    kind = .photo(File(url: attachment.url))
                } else {
                    kind = .custom(AttachmentFile(url: attachment.url, name: attachment.name))
                }
            @unknown default:
                kind = .text("")
            }

            return ChatMessage(sender: sender,
                               messageId: $0.id,
                               sentDate: $0.createdAt,
                               kind: kind,
                               creator: $0.creator,
                               keyboard: $0.keyboard)
        }
    }

    private func messageHistoryReceived(items: [Message]) {
        guard !items.isEmpty else {
            isCanLoadMore = false
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            
            self.isLoadingMore = false
            //   var newMessages = self.convertMessages(items)
            var newMessages = Array(Set(self.convertMessages(items)).subtracting(self.messages))
            if newMessages.count != self.messages.count || self.messages.count == 1 {
                let currentDate = self.messages.first?.sentDate ?? Date()
                let receivedDate = newMessages.last?.sentDate ?? Date()
                newMessages.sort(by: { $0.sentDate < $1.sentDate })
                DispatchQueue.main.async {
                    if !self.messages.isEmpty, receivedDate.compare(currentDate) == .orderedAscending {
                        self.onLoadMoreMessages?(newMessages)
                    } else {
                        self.onMessagesReceived?(newMessages)
                        self.isContentLoaded = true
                    }
                }
            }
        }
    }
}
