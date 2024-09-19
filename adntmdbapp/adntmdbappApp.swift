import SwiftUI
import Atlantis
@main
struct adntmdbappApp: App {
  
  init() {
    // 2. Connect to your Macbook
    Atlantis.start(hostName: "asks-macbook-pro.local.")
  }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
