import SwiftUI

struct FavoriteView: View {
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        NavigationView {
            List {
                ForEach($networkManager.favoriteMovies) { $movie in
                    NavigationLink(destination: MovieDetailView(movie: $movie, networkManager: networkManager)) {
                        MovieRowView(movie: $movie, networkManager: networkManager)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}