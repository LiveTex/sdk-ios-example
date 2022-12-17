# sdk-ios
iOS SDK и демо-приложение для нового VisitorAPI
# Установка
Откройте Ваш проект в XCode, затем перейдите на вкладку General → Найдите раздел Framework, Libraries, and Embedded Content → Нажмите Add items(значок плюс) → Add other… → Выберите LivetexCore.xcframework из проекта LivetexMessaging в папке LivetexCore.
# Настройка
Для инициализации чата и SDK в коде приложения для iOS потребуется указать идентификатор точки контакта.
Для этого добавьте запись в Info.plist как показано ниже:
```
<key>Livetex</key>
<dict>
    <key>LivetexAppID</key>
    <string>touchPoint</string>
</dict>
```
# Использование
## Установка кастомного эндпоинта для подключения
```
let loginService = LivetexAuthService(token: "visitorToken", deviceToken: "apns deviceToken", authPath: "your authentication url")
```
## Авторизация и установление соединения с сервером
```
let loginService = LivetexAuthService(token: "visitorToken", deviceToken: "apns deviceToken")
loginService.requestAuthorization { [weak self] result in
    DispatchQueue.main.async {
        switch result {
        case let .success(token):
            let sessionService = LivetexSessionService(token: token)
            sessionService.connect()
        case let .failure(error):
            print(error.localizedDescription)
        }
    }
}
```
## Отправка событий
```
let event = ClientEvent(.text("Hello world"))
sessionService.sendEvent(event)
```
## Получение событий
```
sessionService.onEvent = { [weak self] event in
    switch event {
        case let .state(result):
            doSomething()
        case .attributes:
            doSomething()
    }
}
```
