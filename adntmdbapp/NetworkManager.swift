import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var movies: [Movie] = []
    @Published var favoriteMovies: [Movie] = []
    @Published var currentCategory: MovieCategory = .popular
    var currentPage = 1
    var totalPages = 1
    private var favoriteIds: Set<Int> = []

    init() {
        loadFavorites()
    }

    private var apiKey: String {
        if let path = Bundle.main.path(forResource: Constants.Secrets.plistName, ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict[Constants.Secrets.apiKeyKey] as? String {
            return apiKey
        }
        return ""
    }

    private let baseURL = Constants.API.baseURL
    private let imageBaseURL = Constants.Image.baseURL

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

    func fetchMovies(for category: MovieCategory) {
        currentCategory = category
        currentPage = 1
        movies = []
        fetchMoviesPage()
    }

    func fetchMoviesPage() {
        guard currentPage <= totalPages else { return }
        let urlString = "\(baseURL)/discover/movie?api_key=\(apiKey)&page=\(currentPage)&sort_by=\(currentCategory.rawValue)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        let newMovies = movieResponse.results.map { movie in
                            Movie(id: movie.id,
                                  title: movie.title,
                                  overview: movie.overview,
                                  posterPath: movie.posterPath,
                                  rating: movie.voteAverage, // Add this line
                                  isFavorite: self.favoriteIds.contains(movie.id),
                                  categoryId: self.currentCategory.rawValue)
                        }
                        self.movies.append(contentsOf: newMovies)
                        self.currentPage += 1
                        self.totalPages = movieResponse.totalPages
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }

    func posterImage(for movie: Movie) -> some View {
        Group {
            if let posterPath = movie.posterPath {
                AsyncImage(url: URL(string: "\(imageBaseURL)\(posterPath)")) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    case .failure:
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                Image(systemName: "photo")
                    .foregroundColor(.gray)
            }
        }
    }

    func toggleFavorite(for movie: Movie) {
        if favoriteIds.contains(movie.id) {
            favoriteIds.remove(movie.id)
            favoriteMovies.removeAll { $0.id == movie.id }
        } else {
            favoriteIds.insert(movie.id)
            favoriteMovies.append(movie)
        }
        
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isFavorite.toggle()
        }
        
        saveFavorites()
        objectWillChange.send()
    }

    func isFavorite(_ movie: Movie) -> Bool {
        favoriteIds.contains(movie.id)
    }

    private func saveFavorites() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(favoriteMovies) {
            UserDefaults.standard.set(encoded, forKey: "FavoriteMovies")
        }
    }

    private func loadFavorites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: "FavoriteMovies") {
            let decoder = JSONDecoder()
            if let loadedFavorites = try? decoder.decode([Movie].self, from: savedFavorites) {
                favoriteMovies = loadedFavorites
                favoriteIds = Set(loadedFavorites.map { $0.id })
            }
        }
    }
}
