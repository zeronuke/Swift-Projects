//
//  FavoritesViewController.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation
import UIKit

// ViewController for the FavoritesViewController
class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FavoriteEpisodeProtocol {
  var tableView: UITableView?
  var showService: ShowService?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // setup viewcontrollers
    view.backgroundColor = .systemRed
    
    showService = ShowService.sharedInstance
    
    tableView = UITableView(frame: self.view.frame)
    if let tableView = tableView {
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(FavoritesCell.self, forCellReuseIdentifier: "FavoriteCell")
      self.view.addSubview(tableView);
    }
    title = "Favorites"
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView?.reloadData()
  }

  func setFavoriteEpisode(for cell: UITableViewCell, isFavorite: Bool) {
    // no-op
  }
  
  func setFavoriteEpisode(for id: String, isFavorite: Bool) {
    showService?.setFavorite(for:id, setFavorite: isFavorite)
  }
  
  func checkFavoriteEpisode(for id: String) -> Bool {
    let isFavorite = showService!.checkFavorite(episodeId: id)
    return isFavorite
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 90.0
    
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView?.deselectRow(at: indexPath, animated: false)
    if let showService = showService {
      if let episodeArray = showService.favoritesArray {
        let rootVC = EpisodeDetailViewController()
        rootVC.initialize(with: episodeArray[indexPath.row], delegate: self)
        let myNavigationController = UINavigationController(rootViewController: rootVC)
        self.present(myNavigationController, animated: true, completion: nil)
      }
    }
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return showService!.favoritesArray!.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for:indexPath) as! FavoritesCell
    cell.prepareForReuse()
    if let showService = showService {
      if let favoritesArray = showService.favoritesArray {
        cell.configure(with: favoritesArray[indexPath.row])
      }
    }
    return cell
  }

  //MARK: FavoriteEpisodeProtocol
    func updateData() {
      self.tableView?.reloadData()
    }
    
  
}
