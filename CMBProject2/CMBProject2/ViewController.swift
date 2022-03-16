
import UIKit

class ViewController: UITabBarController {
  var showService: ShowService?
  override func viewDidLoad() {
    super.viewDidLoad()
    showService = ShowService.sharedInstance
    if let showService = showService {
      if (!showService.getData()) {
        print ("Data is not valid.")
      }
    }
    
    let vc1 = UINavigationController(rootViewController:EpisodesViewController())
    let vc2 = UINavigationController(rootViewController:FavoritesViewController())

    vc1.title = "Episodes"
    vc2.title = "Favorites"

    self.setViewControllers([vc1, vc2], animated: true)
    guard let items = self.tabBar.items else {
      return
    }
    let images = ["house", "star"]
    
    for x in 0...items.count-1 {
      items[x].image = UIImage(systemName: images[x])
    }
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

  }
}



