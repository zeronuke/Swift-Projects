//
//  EpisodesViewController.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation
import UIKit

private var kCellHeight = 90.0

protocol FavoriteEpisodeProtocol : AnyObject {
  // Set or unset favorite episode given a cell.
  func setFavoriteEpisode(for cell: UITableViewCell, isFavorite: Bool)
  // Set or unset favorite episode given an episode ID.
  func setFavoriteEpisode(for id: String, isFavorite: Bool)
  // Check if an episode with ID is a favorite.
  func checkFavoriteEpisode(for id: String) -> Bool
  // Update data source to reflect any changes in data, whicha  can be triggered by
  func updateData()
}

class EpisodesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FavoriteEpisodeProtocol {
  var tableView: UITableView?
  var headerImageURL: String?
  var headerImageView: HeaderImageView?
  var showService: ShowService?
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    // setup viewcontrollers
    view.backgroundColor = .systemBlue
    showService = ShowService.sharedInstance
    tableView = UITableView(frame: self.view.frame)

    if let tableView = tableView {
      tableView.dataSource = self
      tableView.delegate = self
      tableView.register(EpisodeCell.self, forCellReuseIdentifier: "EpisodeCell")
      self.view.addSubview(tableView);
    }
    if (self.headerImageView == nil) {
      let headerImageFrame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 180)
      self.headerImageView = HeaderImageView(frame:headerImageFrame)
      if let show = showService?.show {
        let imageDict = show.showImageURL
        if (imageDict["medium"] != nil) {
          let imageURLString = imageDict["medium"]! as String
          self.headerImageView!.configure(title: showService!.show!.title,
                                       episodes: showService!.episodeArray!.count,
                                        seasons: showService!.seasons!,
                                        summary: showService!.show!.summary,
                                 imageURLString: imageURLString,
                                          frame: headerImageFrame)
        }
      }
    }
    self.tableView?.tableHeaderView = self.headerImageView
    title = "Episodes"
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    tableView?.reloadData()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tableView!.frame = self.view.frame
    tableView!.center = self.view.center
    tableView!.center = view.center
  }
  
  func setFavoriteEpisode(for cell: UITableViewCell, isFavorite: Bool) {
    if let indexPath = tableView!.indexPath(for: cell) {
      showService?.setFavorite(for:indexPath.row, setFavorite: isFavorite)
    }
  }
  
  func setFavoriteEpisode(for id: String, isFavorite: Bool) {
    showService?.setFavorite(for:id, setFavorite: isFavorite)
  }
  
  func checkFavoriteEpisode(for id: String) -> Bool {
    let isFavorite = showService!.checkFavorite(episodeId: id)
    return isFavorite
  }

//MARK: UITableViewDelegate
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return kCellHeight
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    self.tableView?.deselectRow(at: indexPath, animated: false)
    if let showService = showService {
      if let episodeArray = showService.episodeArray {
        let rootVC = EpisodeDetailViewController()
        rootVC.initialize(with: episodeArray[indexPath.row], delegate: self)
        let myNavigationController = UINavigationController(rootViewController: rootVC)
        self.present(myNavigationController, animated: true, completion: nil)
      }
    }  
  }

//MARK: UITableViewDataSource
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return showService!.episodeArray!.count
    
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for:indexPath) as! EpisodeCell
    cell.prepareForReuse()
    if let showService = showService {
      if let episodeArray = showService.episodeArray {
        cell.configure(with: episodeArray[indexPath.row], delegate: self)
      }
    }
    return cell
  }
  
//MARK: FavoriteEpisodeProtocol
  func updateData() {
    self.tableView?.reloadData()
  }
  
}
