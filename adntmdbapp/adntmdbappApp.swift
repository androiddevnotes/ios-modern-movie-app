import SwiftUI
import Atlantis
@main
struct adntmdbappApp: App {
  
  init() {
    
    Atlantis.start(hostName: "asks-macbook-pro.local.")
  }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
