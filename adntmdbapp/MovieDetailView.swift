import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var movie: Movie
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Poster Image
                ZStack(alignment: .bottomLeading) {
                    networkManager.posterImage(for: movie)
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 400)
                        .frame(maxWidth: .infinity)
                        .clipped()
                    
                    LinearGradient(gradient: Gradient(colors: [Color.clear, Color.black.opacity(0.8)]), startPoint: .top, endPoint: .bottom)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", movie.rating))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding()
                }
                .frame(height: 400)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Overview
                    Text("Overview")
                        .font(.headline)
                    Text(movie.overview)
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    // Favorite Button
                    Button(action: {
                        networkManager.toggleFavorite(for: movie)
                    }) {
                        HStack {
                            Image(systemName: networkManager.isFavorite(movie) ? "heart.fill" : "heart")
                            Text(networkManager.isFavorite(movie) ? "Remove from Favorites" : "Add to Favorites")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(networkManager.isFavorite(movie) ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}