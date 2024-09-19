import SwiftUI

struct FavoriteView: View {
  @ObservedObject var favoritesManager: FavoritesManager

  var body: some View {
    ScrollView {

    }

    .navigationTitle("Favorites")
    .overlay(emptyStateView)
  }

}
