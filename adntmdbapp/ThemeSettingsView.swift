import SwiftUI

struct ThemeSettingsView: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      Form {
        Picker("App Theme", selection: $themeManager.selectedTheme) {
          ForEach(ThemeManager.Theme.allCases) { theme in
            Text(theme.rawValue.capitalized)
          }
        }
        .pickerStyle(SegmentedPickerStyle())
      }
      .navigationTitle("Theme Settings")
      .navigationBarItems(
        trailing: Button("Done") {
          presentationMode.wrappedValue.dismiss()
        })
    }
  }
}
