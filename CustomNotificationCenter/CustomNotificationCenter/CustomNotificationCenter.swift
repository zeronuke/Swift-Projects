//
//  CustomNotificationCenter.swift
//  CustomNotificationCenter
//
//  Created by Mark Shen on 11/28/21.
//

import Foundation

class CustomNotificationCenter: CustomNotificationCenterProtocol {
  var observerMap : [String : [Any]]
  static let shared = CustomNotificationCenter()
  
  private init() {}
  
  private var notificationsMap: [String: CustomNotification] = [:]
}
