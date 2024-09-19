import Foundation

class FavoritesManager: ObservableObject {
  @Published var favoriteMovies: [Movie] = []
  private var favoriteIds: Set<Int> = []

  init() {
    loadFavorites()
  }

  func toggleFavorite(for movie: Movie) {
    if favoriteIds.contains(movie.id) {
      favoriteIds.remove(movie.id)
      favoriteMovies.removeAll { $0.id == movie.id }
    } else {
      favoriteIds.insert(movie.id)
      favoriteMovies.append(movie)
    }
    saveFavorites()
  }

  func isFavorite(_ movie: Movie) -> Bool {
    favoriteIds.contains(movie.id)
  }

  func removeFromFavorites(_ movie: Movie) {
    favoriteMovies.removeAll { $0.id == movie.id }
    favoriteIds.remove(movie.id)
    saveFavorites()
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
