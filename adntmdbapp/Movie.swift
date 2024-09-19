import Foundation

struct Movie: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    var isFavorite: Bool = false
    let categoryId: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        isFavorite = false
        categoryId = ""
    }

    init(id: Int, title: String, overview: String, posterPath: String?, isFavorite: Bool, categoryId: String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.isFavorite = isFavorite
        self.categoryId = categoryId
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case results
        case totalPages = "total_pages"
    }
}