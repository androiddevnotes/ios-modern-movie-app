import Atlantis
import SwiftUI

@main
struct adntmdbappApp: App {
  @StateObject private var themeManager = ThemeManager()

  init() {
    Atlantis.start(hostName: "asks-macbook-pro.local.")
  }

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environmentObject(themeManager)
        .preferredColorScheme(themeManager.selectedTheme.colorScheme)
    }
  }
}
