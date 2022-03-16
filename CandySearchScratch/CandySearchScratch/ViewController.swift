//
//  ViewController.swift
//  CandySearchScratch
//
//  Created by Mark Shen on 1/16/22.
//

import UIKit

class ViewController: UIViewController {
  var candyService: CandyService?
  override func viewDidLoad() {
    super.viewDidLoad()
    candyService = CandyService()
    candyService.initCandyData()
  }


}

