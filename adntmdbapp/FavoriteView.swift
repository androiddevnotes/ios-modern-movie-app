import SwiftUI

struct FavoriteView: View {
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        NavigationView {
            List {
                ForEach($networkManager.movies.filter { $0.isFavorite.wrappedValue }) { $movie in
                    MovieRowView(movie: $movie, networkManager: networkManager)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}