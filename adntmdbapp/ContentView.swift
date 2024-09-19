import SwiftUI

struct ContentView: View {
    @StateObject private var networkManager = NetworkManager()

    var body: some View {
        TabView {
            MovieListView(networkManager: networkManager)
                .tabItem {
                    Label("Movies", systemImage: "film")
                }
            
            FavoriteView(networkManager: networkManager)
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
        }
    }
}

struct MovieListView: View {
    @ObservedObject var networkManager: NetworkManager

    var body: some View {
        NavigationView {
            List {
                ForEach($networkManager.movies) { $movie in
                    ZStack(alignment: .leading) {
                        NavigationLink(destination: MovieDetailView(movie: $movie, networkManager: networkManager)) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        MovieRowView(movie: $movie, networkManager: networkManager)
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
    @Binding var movie: Movie
    @ObservedObject var networkManager: NetworkManager

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
            Spacer()
            Button(action: {
                networkManager.toggleFavorite(for: movie)
            }) {
                Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(movie.isFavorite ? .red : .gray)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

