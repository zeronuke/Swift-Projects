//
//  Candy.swift
//  ViewControllerPlayground
//
//  Created by Mark Shen on 11/27/21.
//

import Foundation

struct Candy: Decodable {
  let name: String
  let Category: Category
  
  enum Category: Decodable {
    case all
    case chocolate
    case hard
    case other
  }
}
extension Candy.Category: CaseIterable {}

extension Candy.Category: RawRepresentable {
  typealias RawValue = String
  init?(rawValue: RawValue) {
    switch rawValue {
    case "All": self = .all
      
    }
    
  }
}
