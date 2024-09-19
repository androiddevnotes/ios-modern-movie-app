import Foundation

class NetworkManager: ObservableObject {
    @Published var movies: [Movie] = []

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
        guard let url = URL(string: "\(baseURL)?api_key=\(apiKey)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.movies = movieResponse.results
                    }
                } catch {
                    print("Error decoding JSON: \(error)")
                }
            }
        }.resume()
    }
}