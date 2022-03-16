//
//  FavoritesCell.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation
import UIKit

private var kHorizontalEdgeMargin = 16.0
private var kVerticalMargin = 8.0
private var kHorizontalMargin = 8.0
private var kThumbnailDimension = 70.0

class FavoritesCell: UITableViewCell {
  weak var delegate: FavoriteEpisodeProtocol?
  var model: EpisodeData?
  var isFavorite: Bool?
  var imageURLString: String?
  var titleLabel: UILabel?
  var seasonEpisodeLabel: UILabel?
  var favoriteButton: UIButton?
  var episodeImageView: UIImageView?
  
  override func prepareForReuse() {
    super.prepareForReuse()
    if (titleLabel == nil) {
        titleLabel = UILabel(frame:CGRect(x: 90, y: kVerticalMargin, width: 350, height: 18))
        titleLabel!.font = UIFont.systemFont(ofSize: 18)
        self.addSubview(titleLabel!)
    }
    if (seasonEpisodeLabel == nil) {
      seasonEpisodeLabel = UILabel(frame:CGRect(x: 90, y: 36, width: 350, height: 18))
      seasonEpisodeLabel?.font = UIFont.systemFont(ofSize: 14)
      self.addSubview(seasonEpisodeLabel!)
    }
    if (episodeImageView == nil) {
      episodeImageView = UIImageView()
      episodeImageView!.frame =  CGRect(x:kHorizontalMargin,
                                        y: kVerticalMargin,
                                        width: kThumbnailDimension,
                                        height: kThumbnailDimension)
      self.addSubview(episodeImageView!)
    }
    episodeImageView?.contentMode = .scaleAspectFill
    episodeImageView?.clipsToBounds = true
  }

  func configure(with model: EpisodeData?) {
    if let model = model {
      self.model = model

      let titleString = model.title
      titleLabel!.text = String(format: "%@", titleString)

      let seasonNumber = model.season
      let episodeNumber = model.number
      if (seasonNumber > 0 || episodeNumber > 0) {
        if (seasonNumber > 0 && episodeNumber > 0) {
          seasonEpisodeLabel!.text = String(format: "Season %d Episode %d",
                                            seasonNumber, episodeNumber)
        } else if (seasonNumber > 0) {
          seasonEpisodeLabel!.text = String(format: "Season %d, Unknown Episode", seasonNumber)
        } else if (episodeNumber > 0) {
          seasonEpisodeLabel!.text = String(format: "Unknown Season, Episode %d", episodeNumber)
        }
      }

      if let imageURLString = model.image["medium"] {
        self.imageURLString = imageURLString
        let imageURL = URL(string: imageURLString)
        URLSession.shared.dataTask(with: imageURL!, completionHandler: { data, response, error in
          guard let data = data, error == nil else { return }
          DispatchQueue.main.async {
            if (self.imageURLString == imageURL?.absoluteString) {
              self.episodeImageView!.image = UIImage(data: data)
            }
          }
        }).resume()
      }
      self.setNeedsLayout()
    }
  }

  override func layoutSubviews() {
    self.backgroundColor = UIColor(
      cgColor:CGColor(red: 64/255.0, green: 200/255.0, blue: 173/255.0, alpha: 1.0))
    
    super.layoutSubviews()
    if (titleLabel != nil) {
      titleLabel!.frame = CGRect(x: 90, y: kVerticalMargin, width: 350, height: 18)
    }
    if (seasonEpisodeLabel != nil) {
      seasonEpisodeLabel!.frame = CGRect(x: 90, y: 36, width: 350, height: 18)
    }
    if (episodeImageView != nil && episodeImageView?.image != nil) {
      episodeImageView!.frame =  CGRect(x:kHorizontalMargin,
                                        y: kVerticalMargin,
                                        width: kThumbnailDimension,
                                        height: kThumbnailDimension)
    }
  }
  
  @objc func onFavoriteTap() {
    if (isFavorite!) {
      if let model = model {
        self.isFavorite = false
        favoriteButton?.imageView!.tintColor = UIColor.gray
        delegate?.setFavoriteEpisode(for: model.id, isFavorite: false)
      }
    } else {
      if let model = model {
        self.isFavorite = true
        favoriteButton?.imageView!.tintColor = UIColor.yellow
        delegate?.setFavoriteEpisode(for: model.id, isFavorite: true)
      }
    }
  }
}
