import Foundation

struct Movie: Identifiable, Decodable {
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
}

struct MovieResponse: Decodable {
    let results: [Movie]
}