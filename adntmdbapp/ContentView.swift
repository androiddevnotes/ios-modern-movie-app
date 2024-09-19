import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        TabView {
            NavigationView {
                MovieListView(networkManager: networkManager)
            }
            .tabItem {
                Label("Movies", systemImage: "film")
            }

            NavigationView {
                FavoriteView(networkManager: networkManager)
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
    }
}

struct MovieListView: View {
    @ObservedObject var networkManager: NetworkManager
    @State private var showingSortView = false

    var body: some View {
        List {
            ForEach($networkManager.movies) { $movie in
                NavigationLink(destination: MovieDetailView(networkManager: networkManager, movie: $movie)) {
                    MovieRowView(movie: $movie, networkManager: networkManager)
                }
            }
            if networkManager.currentPage <= networkManager.totalPages {
                ProgressView()
                    .onAppear {
                        networkManager.fetchMoviesPage()
                    }
            }
        }
        .navigationTitle(Constants.UI.appTitle)
        .navigationBarItems(trailing: Button(action: {
            showingSortView = true
        }) {
            Image(systemName: "arrow.up.arrow.down")
        })
        .sheet(isPresented: $showingSortView) {
            SortView(networkManager: networkManager, isPresented: $showingSortView)
        }
        .refreshable {
            await refreshMovies()
        }
    }

    func refreshMovies() async {
        networkManager.currentPage = 1
        networkManager.movies = []
        networkManager.fetchMoviesPage()
    }
}

struct MovieRowView: View {
    @Binding var movie: Movie
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        HStack {
            networkManager.posterImage(for: movie)
                .frame(width: 50, height: 75)
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text("Rating: \(String(format: "%.1f", movie.rating))")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button(action: {
                networkManager.toggleFavorite(for: movie)
            }) {
                Image(systemName: networkManager.isFavorite(movie) ? "heart.fill" : "heart")
                    .foregroundColor(networkManager.isFavorite(movie) ? .red : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

