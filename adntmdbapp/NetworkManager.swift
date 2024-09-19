import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
    @Published var movies: [Movie] = []
    var currentPage = 1
    var totalPages = 1

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

    func fetchPopularMovies() {
        guard currentPage <= totalPages else { return }
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)&page=\(currentPage)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movies.append(contentsOf: movieResponse.results)
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
        if let index = movies.firstIndex(where: { $0.id == movie.id }) {
            movies[index].isFavorite.toggle()
            objectWillChange.send()  // Notify observers of the change
        }
    }

    var favoriteMovies: [Movie] {
        movies.filter { $0.isFavorite }
    }
}