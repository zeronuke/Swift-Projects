//
//  ShowService.swift
//  CMBProject2
//
//  Created by Mark Shen on 1/16/22.
//

import Foundation

struct ShowData: Decodable {
  let showImageURL: Dictionary<String, String>
  let title: String
  let summary: String
  let embedded: EmbeddedData
  private enum CodingKeys: String, CodingKey {
    case showImageURL = "image", title = "name", summary = "summary", embedded = "_embedded"
  }
}

struct EmbeddedData: Decodable {
  let episodes: [EpisodeData]
}

struct EpisodeData: Decodable {
  let image: Dictionary<String, String>
  let id: String
  let season: Int
  let number: Int
  let summary: String
  let title: String
  private enum CodingKeys: String, CodingKey {
    case image, id, season, number, summary, title = "name"
  }
}

// Singleton class that parses the JSON data and holds onto it.
final class ShowService {
  static let sharedInstance = ShowService()
  // Number of seasons in the show.
  var seasons: Int?
  // Array of all the episodes in the show.
  var episodeArray: [EpisodeData]?
  // Dictionary of all the favorite episodes in the show.
  var favoritesList: Dictionary<String, EpisodeData>?
  // Array of all the favorite episodes.
  var favoritesArray: [EpisodeData]?
  // Data for the show.
  var show: ShowData?
  
  func getData() -> Bool {
    seasons = 0
    favoritesList = Dictionary<String, EpisodeData>()
    favoritesArray = []
    let path = Bundle.main.path(forResource: "data", ofType: "json")!
    let url = URL(fileURLWithPath: path)
    let data = try! Data(contentsOf: url)
    
    let decoder = JSONDecoder()
    var result: ShowData?
    do {
      result = try decoder.decode(ShowData.self, from: data)
    } catch {
      print(error)
      return false
    }
    guard let finalResult = result else {
      return false
    }
    show = finalResult
    episodeArray = show?.embedded.episodes
    for episode in episodeArray! {
      seasons = max(seasons!, episode.season)
    }
    return true
  }
  
  func removeFavorite(id: String) {
    if (favoritesList?[id] != nil) {
      favoritesList?.removeValue(forKey: id)
    }
    if (favoritesArray != nil) {
      for x in 0...favoritesArray!.count-1 {
        if (favoritesArray![x].id == id) {
          favoritesArray!.remove(at: x)
          break;
        }
      }
    }
  }

  func setFavorite(for episodeRow: Int, setFavorite: Bool) {
    if let episodeArray = episodeArray {
      let id = episodeArray[episodeRow].id
      if (favoritesList != nil) {
        if (favoritesList![id] == nil && setFavorite == true) {
          favoritesList![id] = episodeArray[episodeRow]
          favoritesArray?.append(episodeArray[episodeRow])
        } else if (favoritesList![id] != nil && setFavorite == false) {
          favoritesList!.removeValue(forKey: id)
          removeFavorite(id: id)
        }
      }
    }
  }
  
  func setFavorite(for episodeId: String, setFavorite: Bool) {
    if (setFavorite == false) {
      removeFavorite(id: episodeId)
    } else {
      if let episodeArray = episodeArray {
        for x in 0...episodeArray.count - 1 {
          if let episode = episodeArray[x] as EpisodeData? {
            if (episodeId == episode.id) {
              if (favoritesList![episodeId] == nil) {
                favoritesList![episodeId] = episode
                favoritesArray!.append(episode)
                break
              }
            }
          }
        }
      }
    }
  }
  
  func checkFavorite(episodeId: String) -> Bool {
    if (favoritesList != nil) {
      if (favoritesList![episodeId] != nil) {
        return true
      }
    }
    return false
  }
}
