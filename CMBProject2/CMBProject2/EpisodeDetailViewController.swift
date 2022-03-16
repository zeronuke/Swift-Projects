
import Foundation
import UIKit

private var kHorizontalEdgeMargin = 16.0
private var kTitleTopMargin = 16.0
private var kLabelTopMargin = 16.0
private var kButtonSize = 28.0
private var kScrollViewBottomPadding = 80.0

class EpisodeDetailViewController: UIViewController {
  var scrollView: UIScrollView?
  weak var delegate: FavoriteEpisodeProtocol?
  var imageURLString: String?
  var isFavorite: Bool?
  var model: EpisodeData?
  var seasonEpisodeLabel: UILabel?
  var runtimeDateString: UILabel?
  var summaryLabel: UILabel?
  var episodeImageView: UIImageView?
  var favoriteButton: UIButton?
  var titleLabel: UILabel?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let navBarAppearance = UINavigationBarAppearance()
    navigationController?.navigationBar.standardAppearance = navBarAppearance
    view.backgroundColor = .white
    self.initializeViews()
    view.backgroundColor = UIColor(cgColor:CGColor(red: 204/255.0,
                                                   green: 227/255.0,
                                                   blue: 170/255.0,
                                                   alpha: 1.0))
  }
  
  func initializeViews () {
    if (scrollView == nil) {
      self.scrollView = UIScrollView()
      self.view.addSubview(scrollView!)
    }
    scrollView!.frame = self.view.frame
    
    if (episodeImageView == nil) {
      episodeImageView = UIImageView()
      scrollView!.addSubview(self.episodeImageView!)
      episodeImageView?.contentMode = .scaleAspectFill
      episodeImageView?.clipsToBounds = true
    }
    self.episodeImageView!.frame =  CGRect(
        x: 0,
        y:self.view.safeAreaInsets.top,
        width: self.view.frame.width,
        height: 160)
    
    if (titleLabel == nil) {
      titleLabel = UILabel()
      titleLabel!.font = UIFont.systemFont(ofSize: 30)
      scrollView!.addSubview(titleLabel!)
    }
    titleLabel!.frame = CGRect(
      x: kHorizontalEdgeMargin,
      y: self.episodeImageView!.frame.size.height +
          self.episodeImageView!.frame.origin.y +
          kTitleTopMargin,
      width: self.view.frame.size.width - 2*kHorizontalEdgeMargin - kButtonSize,
      height: 18)
    
    if (seasonEpisodeLabel == nil) {
      seasonEpisodeLabel = UILabel()
      seasonEpisodeLabel?.font = UIFont.systemFont(ofSize: 18)
      scrollView!.addSubview(seasonEpisodeLabel!)
    }
    seasonEpisodeLabel?.frame = CGRect(
        x: kHorizontalEdgeMargin,
        y: titleLabel!.frame.origin.y + kLabelTopMargin,
        width: self.view.frame.size.width - 2 * kHorizontalEdgeMargin,
        height: 18)

    
    if (favoriteButton == nil) {
      favoriteButton = UIButton()
      scrollView!.addSubview(favoriteButton!)
      favoriteButton?.tintColor = UIColor.yellow

      let tintedImage = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
      favoriteButton?.setImage(tintedImage!, for: .normal)
      favoriteButton?.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24),
                                                      forImageIn: .normal)
      favoriteButton?.addTarget(self, action: #selector(onFavoriteTap), for: .touchUpInside)
    }
    if let labelFrame = titleLabel?.frame {
      favoriteButton?.frame = CGRect(
          x: self.scrollView!.frame.size.width -  kHorizontalEdgeMargin - kButtonSize,
          y: labelFrame.origin.y,
          width: kButtonSize,
          height: kButtonSize)
    }
    
    if (summaryLabel == nil) {
      summaryLabel = UILabel()
      self.scrollView?.addSubview(summaryLabel!)
    }

    summaryLabel?.frame = CGRect(
         x: kHorizontalEdgeMargin,
         y: self.seasonEpisodeLabel!.frame.origin.y +
             self.seasonEpisodeLabel!.frame.size.height + kLabelTopMargin,
         width: self.scrollView!.frame.size.width - 2 * kHorizontalEdgeMargin,
      height: 200)
    
    self.view.setNeedsLayout()
    self.view.layoutIfNeeded()
  }
  
  override func viewDidLayoutSubviews() {
    let titleNoOfLines = ceil(titleLabel!.intrinsicContentSize.width / titleLabel!.frame.width)
    titleLabel?.numberOfLines = Int(titleNoOfLines)
    titleLabel?.frame.size.height = titleNoOfLines * titleLabel!.intrinsicContentSize.height

    if let model = model {
      let seasonNumber = model.season
      let episodeNumber = model.number
      if (seasonNumber > 0 || episodeNumber > 0) {
        let noOfLines = ceil(seasonEpisodeLabel!.intrinsicContentSize.width /
                             seasonEpisodeLabel!.frame.width)
        seasonEpisodeLabel?.numberOfLines = Int(noOfLines)
        seasonEpisodeLabel?.frame.size.height = noOfLines *
            seasonEpisodeLabel!.intrinsicContentSize.height
        seasonEpisodeLabel!.frame.origin = CGPoint(
          x: kHorizontalEdgeMargin,
          y: titleLabel!.frame.origin.y + titleLabel!.frame.size.height + kLabelTopMargin)
      }
    }
    let summaryNoOfLines = ceil(summaryLabel!.intrinsicContentSize.width /
                                summaryLabel!.frame.width)
    summaryLabel?.numberOfLines = Int(summaryNoOfLines)
    summaryLabel?.frame.size.height = summaryNoOfLines * summaryLabel!.intrinsicContentSize.height
    summaryLabel?.frame.origin = CGPoint(x: kHorizontalEdgeMargin,
                                         y: seasonEpisodeLabel!.frame.origin.y +
                                         seasonEpisodeLabel!.frame.size.height + kLabelTopMargin)
    self.scrollView?.contentSize.height = summaryLabel!.frame.origin.y +
        summaryLabel!.frame.size.height + kScrollViewBottomPadding
  }

  func initialize(with model:EpisodeData, delegate:FavoriteEpisodeProtocol) {
    self.model = model
    self.delegate = delegate
    self.initializeViews()
    
    let titleString = model.title
    titleLabel!.text = String(format: "%@", titleString)

    let seasonNumber = model.season
    let episodeNumber = model.number
    if (seasonNumber > 0 || episodeNumber > 0) {
      if (seasonNumber > 0 && episodeNumber > 0) {
        seasonEpisodeLabel!.text = String(format: "Season %d Episode %d", seasonNumber, episodeNumber)
      } else if (seasonNumber > 0) {
        seasonEpisodeLabel!.text = String(format: "Season %d, Unknown Episode", seasonNumber)
        
      } else if (episodeNumber > 0) {
        seasonEpisodeLabel!.text = String(format: "Unknown Season, Episode %d", episodeNumber)
      }
    }
    
    let summaryString = model.summary
    let str = summaryString.replacingOccurrences(of: "<[^>]+>",
                                                 with: "",
                                                 options: .regularExpression, range: nil)
    summaryLabel!.text = str

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
    
    if (delegate != nil) {
      let isFavorite = delegate.checkFavoriteEpisode(for: model.id)
      self.isFavorite = isFavorite
      if isFavorite {
        favoriteButton?.imageView!.tintColor = UIColor.yellow
      } else {
        favoriteButton?.imageView!.tintColor = UIColor.gray
      }
    }

    self.view.setNeedsLayout()
    title = "Episode Details"
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
  
  // Update parent view controller primarily for favorites data related changes.
  override func viewWillDisappear(_ animated: Bool) {
    guard let parent = self.delegate else {
      return;
    }
    parent.updateData()
  }

}
