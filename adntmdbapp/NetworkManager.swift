import Foundation
import SwiftUI

class NetworkManager: ObservableObject {
  @Published var movies: [Movie] = []
  @Published var favoriteMovies: [Movie] = []
  @Published var currentCategory: MovieCategory = .popular
  var currentPage = 1
  var totalPages = 1
  private var favoriteIds: Set<Int> = []
  @Published var selectedGenres: Set<String> = []
  @Published var selectedYear: Int?
  @Published var minRating: Double = 0.0

  init() {
    loadFavorites()
  }

  private var apiKey: String {
    if let path = Bundle.main.path(forResource: Constants.Secrets.plistName, ofType: "plist"),
      let dict = NSDictionary(contentsOfFile: path),
      let apiKey = dict[Constants.Secrets.apiKeyKey] as? String
    {
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

  func applyFilters() {
    currentPage = 1
    movies = []
    fetchMoviesPage()
  }

  func fetchMoviesPage() {
    guard currentPage <= totalPages else { return }
    var urlString =
      "\(baseURL)/discover/movie?api_key=\(apiKey)&page=\(currentPage)&sort_by=\(currentCategory.rawValue)"

    if !selectedGenres.isEmpty {
      let genreIds = selectedGenres.compactMap { genreNameToId[$0] }.joined(separator: ",")
      urlString += "&with_genres=\(genreIds)"
    }

    if let year = selectedYear {
      urlString += "&primary_release_year=\(year)"
    }

    urlString += "&vote_average.gte=\(minRating)"

    guard let url = URL(string: urlString) else { return }

    URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        do {
          let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
          DispatchQueue.main.async {
            let newMovies = movieResponse.results.map { movie in
              var updatedMovie = movie
              updatedMovie.isFavorite = self.favoriteIds.contains(movie.id)
              updatedMovie.categoryId = self.currentCategory.rawValue
              return updatedMovie
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

  // Updated genre dictionary with all movie genres
  private let genreNameToId = [
    "Action": "28",
    "Adventure": "12",
    "Animation": "16",
    "Comedy": "35",
    "Crime": "80",
    "Documentary": "99",
    "Drama": "18",
    "Family": "10751",
    "Fantasy": "14",
    "History": "36",
    "Horror": "27",
    "Music": "10402",
    "Mystery": "9648",
    "Romance": "10749",
    "Science Fiction": "878",
    "TV Movie": "10770",
    "Thriller": "53",
    "War": "10752",
    "Western": "37",
  ]
}
