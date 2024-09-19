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
          ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
              ForEach(genres, id: \.self) { genre in
                GenreTagView(genre: genre, isSelected: selectedGenres.contains(genre)) {
                  toggleGenre(genre)
                }
              }
            }
            .padding(.vertical, 8)
          }
        }

        Section(header: Text("Release Year")) {
          Picker("Select Year", selection: $selectedYear) {
            Text("Any").tag(nil as Int?)
            ForEach(years, id: \.self) { year in
              Text(String(year)).tag(year as Int?)
            }
          }
          .pickerStyle(WheelPickerStyle())
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

  private func toggleGenre(_ genre: String) {
    if selectedGenres.contains(genre) {
      selectedGenres.remove(genre)
    } else {
      selectedGenres.insert(genre)
    }
  }
}

struct GenreTagView: View {
  let genre: String
  let isSelected: Bool
  let action: () -> Void

  var body: some View {
    Button(action: action) {
      Text(genre)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(isSelected ? Constants.Colors.primary : Color.gray.opacity(0.2))
        .foregroundColor(isSelected ? .white : .primary)
        .cornerRadius(20)
        .overlay(
          RoundedRectangle(cornerRadius: 20)
            .stroke(isSelected ? Constants.Colors.primary : Color.gray, lineWidth: 1)
        )
    }
  }
}
