//
//  NotificationManager.swift
//  Tracker
//
//  Created by Aksilont on 14.04.2022.
//

import UIKit

final class NotificationManager {
        
    static let shared = NotificationManager()
    
    private init() { }
    
    func requestAuthorization() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) { [unowned self] granted, error in
                if granted {
                    print("Разрешение получено!")
                    addObserver()
                } else {
                    print("Разрешение не получено!")
                }
            }
    }
    
    
    private func addObserver() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appMovedToBackground),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(appBecomesActive),
                                               name: UIApplication.didBecomeActiveNotification,
                                               object: nil)
    }
    
    @objc private func appMovedToBackground() {
        getNotificationSettings()
    }
    
    @objc private func appBecomesActive() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    private func getNotificationSettings()  {
        UNUserNotificationCenter.current().getNotificationSettings { [unowned self] settings in
            switch settings.authorizationStatus {
            case .authorized:
                sendNotificationRequest(content: makeNotificationContent(), trigger: makeIntervalNotificationTrigger())
            case .denied:
                print("Разрешений нет")
            case .notDetermined:
                print("Не определено!")
            default:
                print("Other")
            }
        }
    }
    
    private func makeNotificationContent() -> UNNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = "Tracker"
        content.subtitle = "Текущий статус"
        content.body = "Необходимо проверить статус!"
        content.badge = 1
        return content
    }
    
    private func makeIntervalNotificationTrigger() -> UNNotificationTrigger {
        return UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
    }
    
    private func makeCalendarNotificationTrigger() -> UNNotificationTrigger {
        var dateInfo = DateComponents()
        dateInfo.hour = 7
        dateInfo.minute = 0
        return UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
    }
    
    private func sendNotificationRequest(content: UNNotificationContent, trigger: UNNotificationTrigger) {
        let request = UNNotificationRequest(identifier: "alarm", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}
