import SwiftUI

struct FavoriteView: View {
  @ObservedObject var networkManager: NetworkManager
  @EnvironmentObject var themeManager: ThemeManager

  var body: some View {
    ScrollView {
      LazyVStack(spacing: 16) {
        ForEach(networkManager.favoriteMovies) { movie in
          NavigationLink(
            destination: MovieDetailView(networkManager: networkManager, movie: .constant(movie))
          ) {
            MovieRowView(movie: movie, networkManager: networkManager)
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
    if networkManager.favoriteMovies.isEmpty {
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
