//
//  CustomNotificationCenterProtocol.swift
//  CustomNotificationCenter
//
//  Created by Mark Shen on 11/28/21.
//

import Foundation

struct CustomNotification {
  var name: String
  var userInfo: [AnyHashable : Any]?
}

struct CustomObserver {
  var name: String
}

protocol CustomNotificationCenterProtocol: class {
  func post(name: String, object: Any?, userInfo: [AnyHashable : Any?]?)
  func addObserver(forName name: String, object: Any?, queue:  OperationQueue?,
                   completion: (CustomNotification) -> Void)
  func removeObservers(name:String)
}
