//
//  ViewController.swift
//  CMBProject
//
//  Created by Mark Shen on 1/3/22.
//

import UIKit

class ViewController: UITabBarController {

  private let button: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 200, height: 52))
    button.setTitle("Log in", for: .normal)
    button.backgroundColor = .white
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let vc1 = UINavigationController(rootViewController:EpisodesVC())
    let vc2 = UINavigationController(rootViewController:FavoritesVC())

    vc1.title = "Episodes"
    vc2.title = "Favorites"
    
    guard let items = self.tabBar.items else {
      return
    
    }
    let images = ["house", "star"]
    
    for x in 0...items.count {
      items[x].image = UIImage(systemName: images[x])
    }
    
    self.setViewControllers([vc1, vc2], animated: true)
//    self.modalPresentationStyle = .fullScreen
    
    view.backgroundColor = .systemBlue
  }
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

  }
  
  @objc func didTapButton() {
    let tabBarVC = UITabBarController()
   
    present(tabBarVC, animated: true)
    if #available(iOS 15, *) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    
  }

}



class FavoritesVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // setup viewcontrollers
    view.backgroundColor = .systemRed
    title = "Favorites"
    
  }
}
class EpisodesVC: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // setup viewcontrollers
    view.backgroundColor = .systemBlue
    title = "Episodes"
  }
}


