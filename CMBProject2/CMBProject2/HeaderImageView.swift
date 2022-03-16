//
//  HeaderImageView.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/24/22.
//

import Foundation
import UIKit

private var kHorizontalEdgeMargin = 16.0
private var kVerticalMargin = 8.0

class HeaderImageView : UIView {
  var headerImageView: UIImageView?
  var alphaLayer: UIView?
  var titleLabel: UILabel?
  var metadataLabel: UILabel?
  var summaryLabel: UILabel?
  var headerImageURL: String?
  
  func configure(title:String,
                 episodes:Int,
                 seasons:Int,
                 summary:String,
                 imageURLString:String,
                 frame:CGRect) {
    headerImageView = UIImageView()
    alphaLayer = UIView()
    titleLabel = UILabel()
    summaryLabel = UILabel()
    metadataLabel = UILabel()
    
    self.headerImageURL = imageURLString
    let headerImageURL = URL(string:imageURLString)
    URLSession.shared.dataTask(with: headerImageURL!, completionHandler: { data, response, error in
      guard let data = data, error == nil else { return }
      DispatchQueue.main.async {
        if (self.headerImageURL == headerImageURL!.absoluteString) {
          self.headerImageView!.frame = self.frame
          self.headerImageView!.clipsToBounds = true
          self.headerImageView!.contentMode = .scaleAspectFill
          self.headerImageView!.image = UIImage(data: data)
        }
      }
    }).resume()
    self.addSubview(headerImageView!)
    let alphaLayer = UIView()
    alphaLayer.frame = frame
    alphaLayer.backgroundColor = .black
    alphaLayer.alpha = 0.7
    self.addSubview(alphaLayer)

    titleLabel!.text = title
    titleLabel?.frame = CGRect(x: kHorizontalEdgeMargin, y: kVerticalMargin, width: self.frame.size.width - 2 * kHorizontalEdgeMargin, height: 18)
    let titleNoOfLines = ceil(titleLabel!.intrinsicContentSize.width / titleLabel!.frame.width)
    titleLabel?.numberOfLines = Int(titleNoOfLines)
    titleLabel?.frame.size.height = titleNoOfLines * titleLabel!.intrinsicContentSize.height
    titleLabel?.textColor = .white
    self.addSubview(titleLabel!)
    
    let titleFrame = titleLabel?.frame
    if let label = metadataLabel {
    label.text = String(format: "%d Seasons, %d Episodes", seasons, episodes);
        label.frame = CGRect(
        x: kHorizontalEdgeMargin,
        y: titleFrame!.origin.y + titleFrame!.size.height + kVerticalMargin,
        width: self.frame.size.width - 2 * kHorizontalEdgeMargin,
        height: 18)
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .white
    self.addSubview(label)
    }
    
    let metadataFrame = metadataLabel?.frame
    let summaryString = summary
    let str = summaryString.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    self.summaryLabel!.text = str
    self.summaryLabel?.frame = CGRect(
        x: kHorizontalEdgeMargin,
        y: metadataFrame!.origin.y + metadataFrame!.size.height + kVerticalMargin,
        width: self.frame.size.width - 2 * kHorizontalEdgeMargin,
        height: 18)
    summaryLabel?.font = UIFont.systemFont(ofSize: 10)
    let summaryNoOfLines = ceil(summaryLabel!.intrinsicContentSize.width / summaryLabel!.frame.width)
    summaryLabel?.numberOfLines = Int(summaryNoOfLines)
    summaryLabel?.frame.size.height = summaryNoOfLines * summaryLabel!.intrinsicContentSize.height
    summaryLabel?.textColor = .white
    self.addSubview(summaryLabel!)
    
    
  }
}
