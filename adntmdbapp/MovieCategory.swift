import Foundation

enum MovieCategory: String, CaseIterable {
  case popular = "popularity.desc"
  case upcoming = "primary_release_date.asc"
  case nowPlaying = "primary_release_date.desc"
  case topRated = "vote_average.desc"

  var displayName: String {
    switch self {
    case .popular: return "Popular"
    case .upcoming: return "Upcoming"
    case .nowPlaying: return "Now Playing"
    case .topRated: return "Top Rated"
    }
  }
}
