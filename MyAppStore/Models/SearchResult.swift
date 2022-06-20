
import Foundation


struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}
struct Result: Decodable {
    let screenshotUrls: [String]
    let trackName: String
    let primaryGenreName: String
    let artworkUrl512: String
    var averageUserRating: Float?
}
