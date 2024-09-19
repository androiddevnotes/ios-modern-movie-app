import SwiftUI

struct FavoriteView: View {
  @ObservedObject var favoritesManager: FavoritesManager

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(favoritesManager.favoriteMovies) { movie in
          NavigationLink(
            destination: MovieDetailView(
              networkManager: NetworkManager(favoritesManager: favoritesManager),
              favoritesManager: favoritesManager,
              movie: .constant(movie)
            )
          ) {
            MovieRowView(
              movie: movie,
              networkManager: NetworkManager(favoritesManager: favoritesManager),
              favoritesManager: favoritesManager
            )
          }
          .buttonStyle(PlainButtonStyle())
        }
      }
      .padding()
    }
    .background(Color(UIColor.systemBackground))
    .navigationTitle("Favorites")
    .overlay(emptyStateView)
  }

  @ViewBuilder
  private var emptyStateView: some View {
    if favoritesManager.favoriteMovies.isEmpty {
      VStack(spacing: 16) {
        Image(systemName: "heart.slash")
          .font(.system(size: 60))
          .foregroundColor(.gray)
        Text("No favorites yet")
          .font(.title2)
          .foregroundColor(.gray)
        Text("Add movies to your favorites list")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
    }
  }
}
