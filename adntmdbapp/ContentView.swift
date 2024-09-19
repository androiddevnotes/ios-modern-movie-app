import SwiftUI

struct ContentView: View {
  @StateObject private var favoritesManager = FavoritesManager()
  @StateObject private var networkManager: NetworkManager
  @EnvironmentObject var themeManager: ThemeManager
  @State private var showingSettings = false
  @State private var showingSortView = false
  @State private var showingFilterView = false
  @State private var selectedTab = 0

  init() {
    let favoritesManager = FavoritesManager()
    _networkManager = StateObject(wrappedValue: NetworkManager(favoritesManager: favoritesManager))
  }

  var body: some View {
    TabView(selection: $selectedTab) {
      NavigationView {
        MovieListView(networkManager: networkManager, favoritesManager: favoritesManager)
          .navigationBarItems(leading: leadingBarItems, trailing: trailingBarItems)
          .navigationBarTitleDisplayMode(.inline)
      }
      .tabItem {
        Label("Movies", systemImage: "film")
      }
      .tag(0)

      NavigationView {
        FavoriteView(favoritesManager: favoritesManager)
          .navigationBarItems(trailing: settingsButton)
          .navigationBarTitleDisplayMode(.inline)
      }
      .tabItem {
        Label("Favorites", systemImage: "heart.fill")
      }
      .tag(1)
    }
    .accentColor(Constants.Colors.primary)
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

  private var leadingBarItems: some View {
    Text(selectedTab == 0 ? "Movies" : "Favorites")
      .font(.title2)
      .fontWeight(.bold)
      .foregroundColor(Constants.Colors.primary)
  }

  private var trailingBarItems: some View {
    HStack(spacing: 16) {
      Button(action: { showingSortView = true }) {
        Image(systemName: "arrow.up.arrow.down")
          .imageScale(.large)
      }
      Button(action: { showingFilterView = true }) {
        Image(systemName: "line.3.horizontal.decrease.circle")
          .imageScale(.large)
      }
      settingsButton
    }
    .foregroundColor(Constants.Colors.primary)
  }

  private var settingsButton: some View {
    Button(action: { showingSettings = true }) {
      Image(systemName: "gearshape.fill")
        .imageScale(.large)
    }
  }
}

struct MovieListView: View {
  @ObservedObject var networkManager: NetworkManager
  @ObservedObject var favoritesManager: FavoritesManager
  @State private var showingSortView = false
  @State private var showingFilterView = false

  var body: some View {
    VStack(spacing: 0) {
      SearchBar(
        text: $networkManager.searchQuery,
        onCommit: {
          networkManager.searchMovies()
        }
      )
      .padding()
      .background(Color(UIColor.secondarySystemBackground))

      ScrollView {
        LazyVStack(spacing: 16) {
          ForEach(networkManager.movies) { movie in
            NavigationLink(
              destination: MovieDetailView(
                networkManager: networkManager,
                favoritesManager: favoritesManager,
                movie: .constant(movie)
              )
            ) {
              MovieRowView(
                movie: movie,
                networkManager: networkManager,
                favoritesManager: favoritesManager
              )
            }
            .buttonStyle(PlainButtonStyle())
          }
          if networkManager.currentPage <= networkManager.totalPages {
            ProgressView()
              .frame(maxWidth: .infinity, alignment: .center)
              .onAppear {
                networkManager.fetchMoviesPage()
              }
          }
        }
        .padding()
      }
    }
    .background(Color(UIColor.systemBackground))
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
  @ObservedObject var favoritesManager: FavoritesManager
  @State private var isAnimating = false

  var body: some View {
    HStack(spacing: 16) {
      networkManager.posterImage(for: movie)
        .frame(width: 80, height: 120)
        .cornerRadius(8)
        .shadow(radius: 4)

      VStack(alignment: .leading, spacing: 8) {
        Text(movie.title)
          .font(.headline)
          .lineLimit(2)

        HStack {
          Image(systemName: "star.fill")
            .foregroundColor(.yellow)
          Text(String(format: "%.1f", movie.rating))
            .font(.subheadline)
          Spacer()
          Text(formattedReleaseDate)
            .font(.caption)
            .foregroundColor(.secondary)
        }

        Text(movie.overview)
          .font(.caption)
          .foregroundColor(.secondary)
          .lineLimit(3)
      }

      VStack {
        Spacer()
        favoriteButton
        Spacer()
      }
    }
    .padding()
    .background(Color(UIColor.secondarySystemBackground))
    .cornerRadius(12)
    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
  }

  private var favoriteButton: some View {
    Button(action: {
      withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
        favoritesManager.toggleFavorite(for: movie)
        isAnimating = true
      }
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
        isAnimating = false
      }
    }) {
      Image(systemName: favoritesManager.isFavorite(movie) ? "heart.fill" : "heart")
        .foregroundColor(favoritesManager.isFavorite(movie) ? .red : .gray)
        .scaleEffect(isAnimating ? 1.3 : 1.0)
        .frame(width: 44, height: 44)
        .background(Color(UIColor.systemBackground))
        .clipShape(Circle())
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
    .buttonStyle(PlainButtonStyle())
  }

  private var formattedReleaseDate: String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    if let date = dateFormatter.date(from: movie.releaseDate) {
      dateFormatter.dateFormat = "MMM d, yyyy"
      return dateFormatter.string(from: date)
    }
    return movie.releaseDate
  }
}

struct SearchBar: View {
  @Binding var text: String
  var onCommit: () -> Void

  var body: some View {
    HStack {
      Image(systemName: "magnifyingglass")
        .foregroundColor(.gray)
      TextField("Search movies...", text: $text, onCommit: onCommit)
        .textFieldStyle(PlainTextFieldStyle())
        .autocapitalization(.none)
        .disableAutocorrection(true)
      if !text.isEmpty {
        Button(action: {
          text = ""
          onCommit()
        }) {
          Image(systemName: "xmark.circle.fill")
            .foregroundColor(.gray)
        }
      }
    }
    .padding(12)
    .background(Color(UIColor.systemBackground))
    .cornerRadius(10)
    .overlay(
      RoundedRectangle(cornerRadius: 10)
        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
    )
    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
  }
}
