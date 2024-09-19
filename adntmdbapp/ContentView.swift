import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.movies) { movie in
                    HStack {
                        if let posterPath = movie.posterPath {
                            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 100)
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        VStack(alignment: .leading) {
                            Text(movie.title)
                                .font(.headline)
                            Text(movie.overview)
                                .font(.subheadline)
                                .lineLimit(3)
                        }
                    }
                }
                if networkManager.currentPage <= networkManager.totalPages {
                    ProgressView()
                        .onAppear {
                            networkManager.fetchPopularMovies()
                        }
                }
            }
            .navigationTitle("Popular Movies")
            .onAppear {
                networkManager.fetchPopularMovies()
            }
        }
    }
}

