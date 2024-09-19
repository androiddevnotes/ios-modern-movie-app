import Foundation

struct Movie: Identifiable, Decodable, Equatable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }

    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
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