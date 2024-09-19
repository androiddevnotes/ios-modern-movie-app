import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                networkManager.posterImage(for: movie)
                    .frame(height: 300)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 8) {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Rating: \(String(format: "%.1f", movie.rating))")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(movie.overview)
                        .font(.body)

                    Button(action: {
                        networkManager.toggleFavorite(for: movie)
                    }) {
                        Text(networkManager.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites")
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarTitle(Text(movie.title), displayMode: .inline)
    }
}