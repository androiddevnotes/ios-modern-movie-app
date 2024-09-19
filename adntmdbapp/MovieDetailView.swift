import SwiftUI

struct MovieDetailView: View {
    @Binding var movie: Movie
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "\(Constants.Image.baseURL)\(posterPath)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
                HStack {
                    Text(movie.title)
                        .font(.largeTitle)
                    Spacer()
                    Button(action: {
                        networkManager.toggleFavorite(for: movie)
                    }) {
                        Image(systemName: networkManager.isFavorite(movie) ? "heart.fill" : "heart")
                            .foregroundColor(networkManager.isFavorite(movie) ? .red : .gray)
                    }
                }
                .padding(.top)
                Text(movie.overview)
                    .font(.body)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle(movie.title)
    }
}