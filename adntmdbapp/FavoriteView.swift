import SwiftUI

struct FavoriteView: View {
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        NavigationView {
            List {
                ForEach($networkManager.favoriteMovies) { $movie in
                    NavigationLink(destination: MovieDetailView(networkManager: networkManager, movie: $movie)) {
                        MovieRowView(movie: $movie, networkManager: networkManager)
                    }
                }
            }
            .navigationTitle("Favorites")
        }
    }
}
