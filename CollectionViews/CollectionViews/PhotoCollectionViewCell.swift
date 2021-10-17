//
//  PhotoCollectionViewCell.swift
//  CollectionViews
//
//  Created by Mark Shen on 10/13/21.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
  static let identifier = "PhotoCollectionViewCell"
  var overlayView: OverlayView! {
    didSet {
      print("The view got changed or reinstantiated!\n")
    }
  }
  private let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFill
    imageView.clipsToBounds = true
    return imageView
  }()

  override init(frame:CGRect) {
    super.init(frame: frame)
    contentView.addSubview(imageView)
    overlayView = OverlayView(frame: bounds)
    overlayView.alpha = 1.0
    overlayView.isOpaque = false
    overlayView.backgroundColor = .blue
    contentView.addSubview(overlayView)
    let images = [
      UIImage(named:"i1"),
      UIImage(named:"i2"),
      UIImage(named:"i3"),
      UIImage(named:"i4"),
      UIImage(named:"i5"),    ].compactMap({ $0 })
    imageView.image = images.randomElement()
  }
    
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    imageView.frame = contentView.bounds
    overlayView.frame = contentView.bounds
  }
  
  override var isSelected: Bool {
    didSet{
      if self.isSelected {
        self.alpha = 0.5
        self.overlayView.isHidden = true
      } else {
        self.alpha = 1.0
        self.overlayView.isHidden = false
      }
    }
  }

  
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
}


class OverlayView: UIView {

  
  override var isHidden: Bool {
    get {
      return super.isHidden
    }
    set(v) {
      super.isHidden = v
    }
  }

}
