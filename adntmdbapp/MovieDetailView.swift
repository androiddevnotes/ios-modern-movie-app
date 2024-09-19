import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var movie: Movie
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Full-screen Poster Image
                ZStack(alignment: .bottomLeading) {
                    networkManager.posterImage(for: movie)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: UIScreen.main.bounds.height * 0.6)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    
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
                    // Overview section
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        Text(movie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(6)
                    }
                    .padding(.horizontal)
                    
                    // Additional movie details (example)
                    VStack(alignment: .leading, spacing: 15) {
                        detailRow(title: "Release Date", value: "2023-05-15") // Replace with actual release date
                        detailRow(title: "Genre", value: "Action, Adventure") // Replace with actual genres
                        detailRow(title: "Director", value: "John Doe") // Replace with actual director
                    }
                    .padding(.horizontal)
                    
                    // Favorite button
                    Button(action: {
                        networkManager.toggleFavorite(for: movie)
                    }) {
                        HStack {
                            Image(systemName: networkManager.isFavorite(movie) ? "heart.fill" : "heart")
                            Text(networkManager.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(networkManager.isFavorite(movie) ? Color.red : Constants.Colors.primary)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 30)
            }
        }
        .edgesIgnoringSafeArea(.all)
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
