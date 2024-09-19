import SwiftUI

struct MovieDetailView: View {
  @ObservedObject var networkManager: NetworkManager
  @Binding var movie: Movie
  @Environment(\.presentationMode) var presentationMode
  @Environment(\.colorScheme) var colorScheme
  @State private var showingFilterView = false
  @State private var selectedGenres: Set<String> = []
  @State private var selectedYear: Int?
  @State private var minRating: Double = 0.0

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 0) {

        ZStack(alignment: .bottomLeading) {
          networkManager.posterImage(for: movie)
            .aspectRatio(contentMode: .fill)
            .frame(height: UIScreen.main.bounds.height * 0.6)
            .frame(maxWidth: .infinity)
            .clipped()

          LinearGradient(
            gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .top,
            endPoint: .bottom)

          VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
              .font(.largeTitle)
              .fontWeight(.bold)
              .foregroundColor(.white)

            HStack(spacing: 4) {
              Image(systemName: "star.fill")
                .foregroundColor(.yellow)
              Text(String(format: "%.1f", movie.rating))
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            }
          }
          .padding()
        }
        .frame(height: UIScreen.main.bounds.height * 0.6)

        VStack(alignment: .leading, spacing: 30) {

          VStack(alignment: .leading, spacing: 15) {
            Text(Constants.Strings.overview)
              .font(.title2)
              .fontWeight(.bold)
              .foregroundColor(.primary)
            Text(movie.overview)
              .font(.body)
              .foregroundColor(.secondary)
              .lineSpacing(6)
          }
          .padding(.horizontal)

          VStack(alignment: .leading, spacing: 15) {
            detailRow(title: Constants.Strings.releaseDate, value: "2023-05-15")
            detailRow(title: Constants.Strings.genre, value: "Action, Adventure")
            detailRow(title: Constants.Strings.director, value: "John Doe")
          }
          .padding(.horizontal)
        }
        .padding(.vertical, 30)
      }
    }
    .safeAreaInset(edge: .bottom) {
      Button(action: {
        networkManager.toggleFavorite(for: movie)
      }) {
        HStack {
          Image(systemName: networkManager.isFavorite(movie) ? "heart.fill" : "heart")
          Text(
            networkManager.isFavorite(movie)
              ? Constants.Strings.removeFromFavorites : Constants.Strings.addToFavorites)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(networkManager.isFavorite(movie) ? Color.red : Constants.Colors.primary)
        .foregroundColor(.white)
        .cornerRadius(10)
      }
      .padding(.horizontal)
      .padding(.bottom, 8)
      .background(Color(UIColor.systemBackground).opacity(0.8))
    }
    .edgesIgnoringSafeArea(.top)
  }

  private func detailRow(title: String, value: String) -> some View {
    HStack {
      Text(title)
        .font(.headline)
        .foregroundColor(.primary)
      Spacer()
      Text(value)
        .font(.subheadline)
        .foregroundColor(.secondary)
    }
  }
}
