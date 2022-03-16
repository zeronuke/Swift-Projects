//
//  MovieTableViewCell.swift
//  CVJSONParser
//
//  Created by Mark Shen on 11/29/21.
//

import UIKit

class MovieCell: UITableViewCell {

  @IBOutlet var movieTitleLabel: UILabel!
  @IBOutlet var movieYearLabel: UILabel!
  @IBOutlet var moviePosterImageView: UIImageView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  static let identifier = "MovieCell"
  
  static func nib() -> UINib {
    return UINib(nibName: "MovieCell", bundle: nil)
  }
  
  func configure(with model: Movie) {
    self.movieTitleLabel.text = model.Title
    self.movieYearLabel.text = model.Year
    let url = model.Poster
    if let data = try? Data(contentsOf: URL(string: url)!) {
      self.moviePosterImageView.image = UIImage(data: data)
    }
  }
}
