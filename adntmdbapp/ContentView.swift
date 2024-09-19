import SwiftUI

struct ContentView: View {
  @StateObject private var networkManager = NetworkManager()
  @EnvironmentObject var themeManager: ThemeManager
  @State private var showingSettings = false

  // **Added** state variables for Sort and Filter sheets
  @State private var showingSortView = false
  @State private var showingFilterView = false

  var body: some View {
    TabView {
      NavigationView {
        MovieListView(networkManager: networkManager)
          .toolbar {
            ToolbarItem(placement: .principal) {
              HStack {
                settingsButton

                Button(action: {
                  showingSortView = true
                }) {
                  Image(systemName: "arrow.up.arrow.down")
                }

                Button(action: {
                  showingFilterView = true
                }) {
                  Image(systemName: "line.3.horizontal.decrease.circle")
                }
              }
            }
          }
      }
      .tabItem {
        Label("Movies", systemImage: "film")
      }

      NavigationView {
        FavoriteView(networkManager: networkManager)
          .toolbar {
            ToolbarItem(placement: .principal) {
              settingsButton
            }
          }
      }
      .tabItem {
        Label("Favorites", systemImage: "heart.fill")
      }
    }
    .accentColor(Constants.Colors.primary)
    // **Added** Sort and Filter Sheets
    .sheet(isPresented: $showingSettings) {
      SettingsView()
    }
    .sheet(isPresented: $showingSortView) {
      SortView(networkManager: networkManager, isPresented: $showingSortView)
    }
    .sheet(isPresented: $showingFilterView) {
      FilterView(
        isPresented: $showingFilterView,
        selectedGenres: $networkManager.selectedGenres,
        selectedYear: $networkManager.selectedYear,
        minRating: $networkManager.minRating
      )
      .onDisappear {
        networkManager.applyFilters()
      }
    }
  }

  private var settingsButton: some View {
    Button(action: {
      showingSettings = true
    }) {
      Image(systemName: "gearshape.fill")
    }
  }

}

struct MovieListView: View {
  @ObservedObject var networkManager: NetworkManager
  @State private var showingSortView = false
  @State private var showingFilterView = false

  var body: some View {
    List {
      ForEach(networkManager.movies) { movie in
        NavigationLink(
          destination: MovieDetailView(networkManager: networkManager, movie: .constant(movie))
        ) {
          MovieRowView(movie: movie, networkManager: networkManager)
        }
      }
      if networkManager.currentPage <= networkManager.totalPages {
        ProgressView()
          .onAppear {
            networkManager.fetchMoviesPage()
          }
      }
    }

    .sheet(isPresented: $showingSortView) {
      SortView(networkManager: networkManager, isPresented: $showingSortView)
    }
    .sheet(isPresented: $showingFilterView) {
      FilterView(
        isPresented: $showingFilterView,
        selectedGenres: $networkManager.selectedGenres,
        selectedYear: $networkManager.selectedYear,
        minRating: $networkManager.minRating
      )
      .onDisappear {
        networkManager.applyFilters()
      }
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
  let movie: Movie
  @ObservedObject var networkManager: NetworkManager

  var body: some View {
    HStack(spacing: 15) {
      networkManager.posterImage(for: movie)
        .frame(width: 60, height: 90)
        .cornerRadius(8)

      VStack(alignment: .leading, spacing: 5) {
        Text(movie.title)
          .font(.headline)
          .lineLimit(2)

        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", movie.rating))
            .font(.subheadline)
        }
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
    .padding(.vertical, 8)
  }
}
