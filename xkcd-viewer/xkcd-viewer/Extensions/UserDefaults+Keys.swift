import Foundation

enum UserDefaultsKeys: String {
    case favorites = "Favorites"
}

extension UserDefaults {
    // MARK: Favorites
    func setFavorites(_ value: [String]) {
        set(value, forKey: UserDefaultsKeys.favorites.rawValue)
    }
    
    func getFavorites() -> [String] {
        return array(forKey: UserDefaultsKeys.favorites.rawValue) as? [String] ?? []
    }
}
