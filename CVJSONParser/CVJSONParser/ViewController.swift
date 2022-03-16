//
//  ViewController.swift
//  CVJSONParser
//
//  Created by Mark Shen on 11/28/21.
//

import UIKit
import SafariServices

struct Movie: Codable {
  let Title: String
  let Year: String
  let imdbID: String
  let _Type: String
  let Poster: String
 
  private enum CodingKeys: String, CodingKey {
    case Title, Year, imdbID, _Type = "Type", Poster
  }
}

struct MovieResult: Codable {
  let Search: [Movie]
}


class ViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  let apiKey:String = "5804884e"
  @IBOutlet weak var textField: UITextField!
  @IBOutlet weak var tableView: UITableView!
  var movies = [Movie]()
  override func viewDidLoad() {
    tableView.delegate = self
    tableView.dataSource = self
    textField.delegate = self
    tableView.register(MovieCell.nib(), forCellReuseIdentifier: "MovieCell")
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  // TextField
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    searchMovies()
    return true
  }
  func searchMovies() {
    textField.resignFirstResponder()
    guard let text = textField.text,
              !text.isEmpty else {
      return
    }
    let query = text.replacingOccurrences(of: " ", with: "%20")
    movies.removeAll()
    
    URLSession.shared.dataTask(with: URL(string:"https://www.omdbapi.com/?apikey=5804884e&s=\(query)")!,
                               completionHandler: {data, response, error in
      guard let data = data, error == nil else {
        return
      }
      // Convert data
      var result: MovieResult?
      do {
        result = try JSONDecoder().decode(MovieResult.self, from: data)
      } catch {
        print (error)
      }
      guard let finalResult = result else {
        return
      }
      print("\(finalResult.Search.first?.Title)")
      
      // Update our movies array
      let newMovies = finalResult.Search
      self.movies.append(contentsOf: newMovies)
      
      // Refresh table
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }).resume() // kicks off request, starting it not resuming it wtf
  }
  
  // TableView
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath) as! MovieCell
    cell.configure(with: movies[indexPath.row])
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    // Show Movie detail
    let url = "https://www.imdb.com/title/\(movies[indexPath.row].imdbID)/"
    let vc = SFSafariViewController(url:URL(string: url)!)
    self.present(vc, animated: true, completion: nil)
  }
}

