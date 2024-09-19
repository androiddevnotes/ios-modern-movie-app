import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var selectedMovie: Movie?

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        HStack {
                            networkManager.posterImage(for: movie)
                                .frame(width: 100, height: 150)
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .font(.headline)
                                Text(movie.overview)
                                    .font(.subheadline)
                                    .lineLimit(3)
                            }
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
            .navigationTitle(Constants.UI.appTitle)
            .onAppear {
                networkManager.fetchPopularMovies()
            }
        }
    }
}

