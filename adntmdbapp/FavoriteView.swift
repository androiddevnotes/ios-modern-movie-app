import SwiftUI

struct FavoriteView: View {
    @ObservedObject var networkManager: NetworkManager
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        List {
            ForEach(networkManager.favoriteMovies) { movie in
                NavigationLink(destination: MovieDetailView(networkManager: networkManager, movie: .constant(movie))) {
                    MovieRowView(movie: movie, networkManager: networkManager)
                }
            }
            .onDelete(perform: removeItems)
        }
        .navigationTitle("Favorites")
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let movie = networkManager.favoriteMovies[index]
            networkManager.toggleFavorite(for: movie)
        }
    }
}
