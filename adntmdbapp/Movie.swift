import Foundation

struct Movie: Identifiable, Codable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let rating: Double 
    var isFavorite: Bool
    let categoryId: String
}

struct MovieResponse: Codable {
    let page: Int
    let results: [MovieResult]
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