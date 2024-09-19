import Foundation

struct GenreMapping {
  static let genreNameToId = [
    "Action": "28",
    "Adventure": "12",
    "Animation": "16",
    "Comedy": "35",
    "Crime": "80",
    "Documentary": "99",
    "Drama": "18",
    "Family": "10751",
    "Fantasy": "14",
    "History": "36",
    "Horror": "27",
    "Music": "10402",
    "Mystery": "9648",
    "Romance": "10749",
    "Science Fiction": "878",
    "TV Movie": "10770",
    "Thriller": "53",
    "War": "10752",
    "Western": "37",
  ]

  static let idToName = Dictionary(uniqueKeysWithValues: genreNameToId.map { ($1, $0) })
}
