import SwiftUI

struct MovieDetailView: View {
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let posterPath = movie.posterPath {
                    AsyncImage(url: URL(string: "\(Constants.Image.baseURL)\(posterPath)")) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                }
                Text(movie.title)
                    .font(.largeTitle)
                    .padding(.top)
                Text(movie.overview)
                    .font(.body)
                    .padding(.top)
            }
            .padding()
        }
        .navigationTitle(movie.title)
    }
}