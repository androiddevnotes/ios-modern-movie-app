import SwiftUI

struct SortView: View {
  @ObservedObject var networkManager: NetworkManager
  @Binding var isPresented: Bool
  @EnvironmentObject var themeManager: ThemeManager

  var body: some View {
    NavigationView {
      List {
        ForEach(MovieCategory.allCases, id: \.self) { category in
          Button(action: {
            networkManager.fetchMovies(for: category)
            isPresented = false
          }) {
            HStack {
              Text(category.displayName)
              Spacer()
              if networkManager.currentCategory == category {
                Image(systemName: "checkmark")
                  .foregroundColor(Constants.Colors.primary)
              }
            }
          }
        }
      }
      .navigationTitle("Sort By")
      .navigationBarItems(
        trailing: Button("Done") {
          isPresented = false
        })
    }
    .accentColor(Constants.Colors.primary)
    .background(themeManager.selectedTheme == .dark ? Color.black : Color.white)
  }
}
