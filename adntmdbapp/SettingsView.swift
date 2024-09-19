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

        // You can add more settings sections here
        // For example:
        // Section(header: Text("Notifications")) {
        //     Toggle("Enable Notifications", isOn: .constant(true))
        // }

        // Section(header: Text("About")) {
        //     Text("Version 1.0")
        // }
      }
      .navigationTitle("Settings")
      .navigationBarItems(
        trailing: Button("Done") {
          presentationMode.wrappedValue.dismiss()
        })
    }
  }
}
