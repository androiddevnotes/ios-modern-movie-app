import SwiftUI

class ThemeManager: ObservableObject {
  @AppStorage("selectedTheme") var selectedTheme: Theme = .system

  enum Theme: String, CaseIterable, Identifiable {
    case light, dark, system
    var id: Self { self }

    var colorScheme: ColorScheme? {
      switch self {
      case .light: return .light
      case .dark: return .dark
      case .system: return nil
      }
    }
  }
}
