import Foundation
//
//"id": "10897",
//"url": "http://www.tvmaze.com/episodes/10897/silicon-valley-1x01-minimum-viable-product",
//"name": "Minimum Viable Product",
//"season": 1,
//"number": 1,
//"airdate": "2014-04-06",
//"airtime": "22:00",
//"airstamp": "2014-04-07T02:00:00+00:00",
//"runtime": 30,
//"image": {
//  "medium": "http://static.tvmaze.com/uploads/images/medium_landscape/49/123633.jpg",
//  "original": "http://static.tvmaze.com/uploads/images/original_untouched/49/123633.jpg"
//},
//"summary": "<p>Attending an elaborate launch party, Richard and his computer programmer friends - Big Head, Dinesh and Gilfoyle - dream of making it big. Instead, they're living in the communal Hacker Hostel owned by former programmer Erlich, who gets to claim ten percent of anything they invent there. When it becomes clear that Richard has developed a powerful compression algorithm for his website, Pied Piper, he finds himself courted by Gavin Belson, his egomaniacal corporate boss, who offers a $10 million buyout by his firm, Hooli. But Richard holds back when well-known investor Peter Gregory makes a counteroffer.</p>",
//"_links": {
//  "self": {
//    "href": "http://api.tvmaze.com/episodes/10897"
//  }
//}

struct EpisodeObject: Codable {
  let title: String?
  let image_url: String?
  let content: String?
  
}

struct DashResponse: Codable {
  let header_image_url:String?
  let content_items:[DashObject]?
}

class ContentService {
    /// fetches data for the content of the list
    var items: [DashObject] = []
    var headerURL: URL?
    func getItemData() -> Bool {
        let path = Bundle.main.path(forResource: "Content", ofType: "json")!
        let url = URL(fileURLWithPath: path)
        let data = try! Data(contentsOf: url)
        
        let decoder = JSONDecoder()
        var result: DashResponse?
        do {
          result = try decoder.decode(DashResponse.self, from:data)
        } catch {
          print(error)
          return false
        }
        guard let finalResult = result else {
          return false
        }
        if let headerURLString = finalResult.header_image_url {
            headerURL = URL(string:headerURLString)
          } else {
          
        }
        items = finalResult.content_items

        //TODO: Instead of just printing a string, deserialize into objects and inform view controller
        print(try! JSONSerialization.jsonObject(with: data, options: .allowFragments))
        return true
    }
}
