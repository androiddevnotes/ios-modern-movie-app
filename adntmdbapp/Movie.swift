import Foundation

struct Movie: Identifiable, Codable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let rating: Double
  var isFavorite: Bool
  var categoryId: String  // Changed from 'let' to 'var'
  let genres: [String]
  let releaseDate: String

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case rating = "vote_average"
    case genres
    case releaseDate = "release_date"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    overview = try container.decode(String.self, forKey: .overview)
    posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    rating = try container.decode(Double.self, forKey: .rating)
    genres = try container.decodeIfPresent([String].self, forKey: .genres) ?? []
    releaseDate = try container.decode(String.self, forKey: .releaseDate)

    // These properties are not part of the API response, so we set default values
    isFavorite = false
    categoryId = ""
  }

  init(
    id: Int, title: String, overview: String, posterPath: String?, rating: Double, isFavorite: Bool,
    categoryId: String, genres: [String], releaseDate: String
  ) {
    self.id = id
    self.title = title
    self.overview = overview
    self.posterPath = posterPath
    self.rating = rating
    self.isFavorite = isFavorite
    self.categoryId = categoryId
    self.genres = genres
    self.releaseDate = releaseDate
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(overview, forKey: .overview)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(rating, forKey: .rating)
    try container.encode(genres, forKey: .genres)
    try container.encode(releaseDate, forKey: .releaseDate)
    // We don't encode isFavorite and categoryId as they are not part of the API response
  }
}

struct MovieResponse: Codable {
  let page: Int
  let results: [Movie]
  let totalPages: Int

  enum CodingKeys: String, CodingKey {
    case page
    case results
    case totalPages = "total_pages"
  }
}

struct MovieResult: Codable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let voteAverage: Double

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case voteAverage = "vote_average"
  }
}
