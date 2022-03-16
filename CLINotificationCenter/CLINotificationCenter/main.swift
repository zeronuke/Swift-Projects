//
//  main.swift
//  CLINotificationCenter
//
//  Created by Mark Shen on 11/28/21.
//

import Foundation
typealias myClosure = () -> Void
struct CustomNotification {
 var name: String
 var userInfo: [AnyHashable: Any]?
}
protocol CustomNotificationCenterProtocol: AnyObject {
 func post(name: String, object: Any?, userInfo: [AnyHashable : Any]?)
 func addObserver(forName name: String, object: AnyHashable?, closure: @escaping myClosure)
 func removeObservers(name: String)
}

protocol CustomObserver : Hashable {
  func receiveNotification(userInfo: [AnyHashable : Any]?)
}

class CustomNotificationCenter: CustomNotificationCenterProtocol {
  static let shared = CustomNotificationCenter()
  private init() {}
  private var notificationsMap: [String: [AnyHashable: myClosure]] = [:]

  
  func post(name: String, object: Any?, userInfo: [AnyHashable : Any]?) {
    if let obsArray = notificationsMap[name] {
      for (object, closure) in obsArray {
        closure()
      }
    }
  }
  func addObserver(forName name: String, object: AnyHashable?, closure: @escaping myClosure) {
   if notificationsMap[name] == nil {
     notificationsMap[name] = [object! : closure]
   } else {
     notificationsMap[name]![object!] = closure
   }
   
  }
  func removeObservers(name: String) {
//    observersMap[name] = nil
  }
}

class ObservingGnome {
  var gnomeNumber: Int
  init(number: Int) {
    gnomeNumber = number
    CustomNotificationCenter.shared.addObserver(forName: "gnome", object: self, closure: { () -> Void  in
      print(String(format: "This gnome %d got the notification", gnomeNumber));
    })
  }
  @objc func receiveNotification() {
    print(String(format: "This gnome %d got the notification", gnomeNumber));
  }
}

var myGnome1: ObservingGnome = ObservingGnome.init(number: 1)
var myGnome2: ObservingGnome = ObservingGnome.init(number: 2)
var myGnome3: ObservingGnome = ObservingGnome.init(number: 3)
//CustomNotificationCenter.shared.addObserver(forName: "gnome", object: myGnome1)
//CustomNotificationCenter.shared.addObserver(forName: "gnome", object: myGnome2)
//CustomNotificationCenter.shared.addObserver(forName: "gnome", object: myGnome3)
CustomNotificationCenter.shared.post(name: "gnome", object: nil, userInfo: nil)

print("Hello, World!")

