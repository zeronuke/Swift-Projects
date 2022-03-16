//
//  EpisodeCell.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation
import UIKit

private var kHorizontalPadding = 8.0
private var kVerticalPadding = 8.0
private var kThumbnailDimensions = 70.0

class EpisodeCell: UITableViewCell {
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
      titleLabel = UILabel(frame:CGRect(x: 90,
          y:kVerticalPadding,
          width: self.frame.size.width - 2 * kHorizontalPadding,
          height: 18))
      titleLabel!.font = UIFont.systemFont(ofSize: 18)
      self.addSubview(titleLabel!)
    }
    if (seasonEpisodeLabel == nil) {
      seasonEpisodeLabel = UILabel(frame:CGRect(x: 90,
          y: 36,
          width: self.frame.size.width - 2 * kHorizontalPadding,
          height: 18))
      seasonEpisodeLabel?.font = UIFont.systemFont(ofSize: 14)
      self.addSubview(seasonEpisodeLabel!)
    }
    if (episodeImageView == nil) {
      episodeImageView = UIImageView()
      episodeImageView!.frame = CGRect(x: kHorizontalPadding,
                                       y: kVerticalPadding,
                                       width: kThumbnailDimensions,
                                       height: kThumbnailDimensions)
      self.addSubview(episodeImageView!)
    }
    episodeImageView?.contentMode = .scaleAspectFill
    episodeImageView?.clipsToBounds = true

    if (favoriteButton == nil) {
      favoriteButton = UIButton()
      self.addSubview(favoriteButton!)
      let tintedImage = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
      favoriteButton?.setImage(tintedImage!, for: .normal)
      favoriteButton?.tintColor = UIColor.yellow
      favoriteButton?.imageView?.tintColor = UIColor.yellow
      favoriteButton?.frame = CGRect(x:self.frame.width - 40,
                                     y:self.frame.height - 40,
                                     width: 30,
                                     height: 30)
      favoriteButton?.addTarget(self, action: #selector(onFavoriteTap), for :.touchUpInside)
      
    }
    isFavorite = false
  }

  @objc func onFavoriteTap() {
    if (isFavorite!) {
      self.isFavorite = false
      favoriteButton?.imageView!.tintColor = UIColor.gray
      delegate?.setFavoriteEpisode(for:self, isFavorite: false)
    } else {
      self.isFavorite = true
      favoriteButton?.imageView!.tintColor = UIColor.yellow
      delegate?.setFavoriteEpisode(for :self, isFavorite: true)
    }
  }

  func configure(with model:EpisodeData?, delegate:FavoriteEpisodeProtocol) {
    self.delegate = delegate
    if let model = model {
      self.model = model
      let titleString = model.title
      titleLabel!.text = String(format: "%@", titleString)
      titleLabel!.font = UIFont.systemFont(ofSize: 16)
      let noOfLines = ceil(titleLabel!.intrinsicContentSize.width / titleLabel!.frame.width)
      titleLabel?.numberOfLines = Int(noOfLines)
      titleLabel?.frame.size.height = noOfLines * titleLabel!.intrinsicContentSize.height
      
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
        seasonEpisodeLabel!.font = UIFont.systemFont(ofSize: 14)
        seasonEpisodeLabel!.frame.origin = CGPoint(x: 90, y:titleLabel!.frame.origin.y + titleLabel!.frame.size.height)
      }
      
      if let imageURLString = model.image["medium"] {
        self.imageURLString = imageURLString
        let imageURL = URL(string:imageURLString)
        URLSession.shared.dataTask(
          with:imageURL!, completionHandler: {
            data, response, error in guard let data = data, error == nil
            else {
              return
            }
            DispatchQueue.main.async{
              if (self.imageURLString == imageURL?.absoluteString) {
                self.episodeImageView!.image = UIImage(data:data)
              }
            }
          }).resume()
      }
      
      if (delegate != nil) {
        let isFavorite = delegate.checkFavoriteEpisode(for :model.id)
        self.isFavorite = isFavorite
        if isFavorite {
          favoriteButton?.imageView!.tintColor = UIColor.yellow
        } else {
          favoriteButton?.imageView!.tintColor = UIColor.gray
        }
      }
      self.setNeedsLayout()
    }
  }

  override func layoutSubviews() {
    self.backgroundColor = UIColor(cgColor:
                                    CGColor(red: 247 / 255.0,
                                            green: 200 / 255.0,
                                            blue: 173 / 255.0,
                                            alpha: 1.0))
    super.layoutSubviews()
    if (titleLabel != nil) {
      titleLabel!.frame = CGRect(x: kThumbnailDimensions + 2 * kHorizontalPadding,
                                 y: kVerticalPadding,
                                 width: self.frame.size.width - 3 * kHorizontalPadding -
                                        kThumbnailDimensions,
                                 height: 18)
      let noOfLines = ceil(titleLabel!.intrinsicContentSize.width / titleLabel!.frame.width)

      titleLabel?.numberOfLines = Int(noOfLines)
      titleLabel?.frame.size.height = noOfLines * titleLabel!.intrinsicContentSize.height
    }
    if (seasonEpisodeLabel != nil) {
      let titleFrame = titleLabel!.frame
      seasonEpisodeLabel!.frame = CGRect(x: kThumbnailDimensions + 2 * kHorizontalPadding,
                                         y: titleFrame.origin.y + titleFrame.size.height +
                                            kVerticalPadding,
                                         width: self.frame.size.width - 3 * kHorizontalPadding -
                                                kThumbnailDimensions,
                                         height: 18)
      let noOfLines = ceil(
        seasonEpisodeLabel!.intrinsicContentSize.width / seasonEpisodeLabel!.frame.width)
      seasonEpisodeLabel?.numberOfLines = Int(noOfLines)
      seasonEpisodeLabel?.frame.size.height = noOfLines *
          seasonEpisodeLabel!.intrinsicContentSize.height
    }
    if (episodeImageView != nil && episodeImageView?.image != nil) {
      episodeImageView!.frame = CGRect(x: kHorizontalPadding,
                                       y: kVerticalPadding,
                                       width: kThumbnailDimensions,
                                       height: kThumbnailDimensions)
    }

    favoriteButton?.frame = CGRect(x:self.frame.width - 40,
                                   y:self.frame.height - 40,
                                   width: 30,
                                   height: 30)
    
    if (delegate != nil) {
      let isFavorite = delegate!.checkFavoriteEpisode(for :self.model!.id)
      self.isFavorite = isFavorite
      if isFavorite {
        favoriteButton?.imageView!.tintColor = UIColor.yellow
      } else {
        favoriteButton?.imageView!.tintColor = UIColor.gray
      }
    }
  }
}
