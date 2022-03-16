//
//  Candy.swift
//  CandySearchScratch
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation


struct Candy: Decodable {
  let name:String
  let category:Category
  
  enum Category: Decodable {
    case all
    case chocolate
    case hard
    case other
  }
}

struct CandyCatalog: Decodable {
  let candies:[Candy]
}

class CandyService {
  var candies: CandyCatalog?
  func initCandyData() -> Bool {
    let path = Bundle.main.path(forResource: "candies", ofType: "json")!
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    
    let decoder = JSONDecoder()
    var result: CandyCatalog?
    do {
      result = try decoder.decode(CandyCatalog.self, from: data)
    } catch {
      print(error)
      return false
    }

    guard let finalResult = result else {
      return false
    }
    candies = finalResult
    return true
  }
}
