import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var networkManager: NetworkManager
    @Binding var movie: Movie
    @Environment(\.presentationMode) var presentationMode
    @GestureState private var dragOffset = CGSize.zero
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Poster Image with Overlay
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
                            .shadow(color: .black, radius: 2, x: 0, y: 2)
                        
                        HStack(spacing: 8) {
                            RatingView(rating: movie.rating)
                            Text(String(format: "%.1f", movie.rating))
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
                .frame(height: UIScreen.main.bounds.height * 0.6)
                
                VStack(alignment: .leading, spacing: 24) {
                    // Overview
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Overview")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text(movie.overview)
                            .font(.body)
                            .foregroundColor(.secondary)
                            .lineSpacing(4)
                    }
                    
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
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
                    }
                    .padding(.top)
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: backButton)
        .gesture(DragGesture().updating($dragOffset) { (value, state, transaction) in
            if value.startLocation.x < 20 && value.translation.width > 100 {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
    }
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.white)
                .padding(12)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
    }
}

struct RatingView: View {
    let rating: Double
    let maxRating: Int = 5
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { star in
                Image(systemName: "star.fill")
                    .foregroundColor(star <= Int(rating / 2) ? .yellow : .gray)
            }
        }
    }
}