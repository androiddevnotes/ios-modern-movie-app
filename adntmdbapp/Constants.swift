import Foundation
import SwiftUI

struct Constants {
  struct API {
    static let baseURL = "https://api.themoviedb.org/3"
  }

  struct Image {
    static let baseURL = "https://image.tmdb.org/t/p/w500"
  }

  struct Secrets {
    static let plistName = "Secrets"
    static let apiKeyKey = "API_KEY"
  }

  struct UI {
    static let appTitle = "ADN"
    static let placeholderImage = "placeholder"
  }

  struct Colors {
    static let primary = Color("PrimaryColor")
  }

  struct Strings {
    static let overview = NSLocalizedString("overview", comment: "")
    static let releaseDate = NSLocalizedString("releaseDate", comment: "")
    static let genre = NSLocalizedString("genre", comment: "")
    static let director = NSLocalizedString("director", comment: "")
    static let addToFavorites = NSLocalizedString("addToFavorites", comment: "")
    static let removeFromFavorites = NSLocalizedString("removeFromFavorites", comment: "")
  }
}
