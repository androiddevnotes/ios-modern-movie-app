import SwiftUI

struct SettingsView: View {
  @EnvironmentObject var themeManager: ThemeManager
  @Environment(\.presentationMode) var presentationMode

  var body: some View {
    NavigationView {
      Form {
        Section(header: Text("Appearance")) {
          Picker("App Theme", selection: $themeManager.selectedTheme) {
            ForEach(ThemeManager.Theme.allCases) { theme in
              Text(theme.rawValue.capitalized)
            }
          }
          .pickerStyle(SegmentedPickerStyle())
        }
      }
      .navigationTitle("Settings")
      .navigationBarItems(
        trailing: Button("Done") {
          presentationMode.wrappedValue.dismiss()
        })
    }
  }
}
