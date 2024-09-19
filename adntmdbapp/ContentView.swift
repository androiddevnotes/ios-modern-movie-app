import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var selectedMovie: Movie?

    var body: some View {
        NavigationView {
            List {
                ForEach(networkManager.movies) { movie in
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
                    .onTapGesture {
                        selectedMovie = movie
                    }
                    .background(
                        NavigationLink(destination: MovieDetailView(movie: selectedMovie ?? movie), isActive: Binding(
                            get: { selectedMovie == movie },
                            set: { if !$0 { selectedMovie = nil } }
                        )) {
                            EmptyView()
                        }
                        .hidden()
                    )
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

