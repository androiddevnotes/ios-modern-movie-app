import Foundation

struct Movie: Identifiable, Codable {
  let id: Int
  let title: String
  let overview: String
  let posterPath: String?
  let rating: Double
  let releaseDate: String
  let genres: [String]
  var isFavorite: Bool = false
  var categoryId: String?

  enum CodingKeys: String, CodingKey {
    case id
    case title
    case overview
    case posterPath = "poster_path"
    case rating = "vote_average"
    case releaseDate = "release_date"
    case genres = "genre_ids"
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    id = try container.decode(Int.self, forKey: .id)
    title = try container.decode(String.self, forKey: .title)
    overview = try container.decode(String.self, forKey: .overview)
    posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
    rating = try container.decode(Double.self, forKey: .rating)
    releaseDate = try container.decode(String.self, forKey: .releaseDate)

    let genreIds = try container.decodeIfPresent([Int].self, forKey: .genres) ?? []
    genres = genreIds.map { String($0) }

    isFavorite = false
    categoryId = nil
  }

  init(
    id: Int, title: String, overview: String, posterPath: String?, rating: Double,
    releaseDate: String, genres: [String], isFavorite: Bool = false, categoryId: String? = nil
  ) {
    self.id = id
    self.title = title
    self.overview = overview
    self.posterPath = posterPath
    self.rating = rating
    self.releaseDate = releaseDate
    self.genres = genres
    self.isFavorite = isFavorite
    self.categoryId = categoryId
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(id, forKey: .id)
    try container.encode(title, forKey: .title)
    try container.encode(overview, forKey: .overview)
    try container.encode(posterPath, forKey: .posterPath)
    try container.encode(rating, forKey: .rating)
    try container.encode(releaseDate, forKey: .releaseDate)
    try container.encode(genres.compactMap { Int($0) }, forKey: .genres)
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
