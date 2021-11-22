//
//  MyCollectionViewController.swift
//  CandySearch
//
//  Created by Mark Shen on 11/14/21.
//

import UIKit

let reuseIdentifier = "MyCell"

class MyCollectionViewController: UICollectionViewController {
    var imageFiles = [String]()
    var images = [UIImage]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        self.collectionView.delegate = self
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = falsexou
        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
  func initialize() {

      imageFiles = ["i1.jpeg",
                    "i2.jpeg",
                    "i3,jpeg",
                    "i4.jpeg",
                    "i5.jpeg",
                    "i6.jpeg",
                    "i7.jpeg",
                    "i8.jpeg",
                    "i9.jpeg",
                    "i10.jpeg",
                    "i11.jpeg",
                    "i12.jpeg"]
  
      for fileName in imageFiles {

          if let image = UIImage(named: fileName) {
              images.append(image)
          }
      }
  }
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let image = images[indexPath.row]
    var imageSize = image.size
    if (imageSize.width > view.frame.width) {
      imageSize.width = view.frame.width
      imageSize.height = imageSize.width
      return imageSize
    }
    return image.size
  }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
      return images.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MyCollectionViewCell
        // Configure the cell
        cell.imageView.image = images[indexPath.row]
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
