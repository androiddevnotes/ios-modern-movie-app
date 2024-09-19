import Foundation

class NetworkManager: ObservableObject {
    @Published var movies: [Movie] = []
    var currentPage = 1
    var totalPages = 1

    private var apiKey: String {
        if let path = Bundle.main.path(forResource: "Secrets", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path),
           let apiKey = dict["API_KEY"] as? String {
            return apiKey
        }
        return ""
    }

    private let baseURL = "https://api.themoviedb.org/3/movie/popular"

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
}