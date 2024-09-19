import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.movies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieRowView(movie: movie)
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

struct MovieRowView: View {
    let movie: Movie
    @ObservedObject private var networkManager = NetworkManager()

    var body: some View {
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

