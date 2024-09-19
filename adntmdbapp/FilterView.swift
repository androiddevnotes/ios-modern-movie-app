import SwiftUI

struct FilterView: View {
  @Binding var isPresented: Bool
  @Binding var selectedGenres: Set<String>
  @Binding var selectedYear: Int?
  @Binding var minRating: Double

  let genres = [
    "Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family",
    "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction",
    "TV Movie", "Thriller", "War", "Western",
  ].sorted()

  let years = Array(1900...Calendar.current.component(.year, from: Date())).reversed()

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Genres")) {
          ForEach(genres, id: \.self) { genre in
            Button(action: {
              if selectedGenres.contains(genre) {
                selectedGenres.remove(genre)
              } else {
                selectedGenres.insert(genre)
              }
            }) {
              HStack {
                Text(genre)
                Spacer()
                if selectedGenres.contains(genre) {
                  Image(systemName: "checkmark")
                }
              }
            }
          }
        }

        Section(header: Text("Release Year")) {
          Picker("Select Year", selection: $selectedYear) {
            Text("Any").tag(nil as Int?)
            ForEach(years, id: \.self) { year in
              Text(String(year)).tag(year as Int?)
            }
          }
        }

        Section(header: Text("Minimum Rating")) {
          Slider(value: $minRating, in: 0...10, step: 0.5) {
            Text("Minimum Rating: \(minRating, specifier: "%.1f")")
          }
        }
      }
      .navigationTitle("Filter Movies")
      .navigationBarItems(
        trailing: Button("Apply") {
          isPresented = false
        })
    }
  }
}
