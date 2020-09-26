import Foundation
import UIKit

struct FavoriteItem {
    var title: String
    var disclosureImage: UIImage = UIImage(appImage: .disclosure_indicator)
}

class FavoritesViewModel {
    
    var title: String = NSLocalizedString("favorites.tab.title", comment: "")
    
    //Subscription methods: To be subscribed by view controller
    var pushController: ((UIViewController) -> Void)?
    var refreshFavorites: (() -> Void)?
    
    var favorites: [String] {
        return UserDefaults.standard.getFavorites()
    }
    
    var favoriteItems: [FavoriteItem] = []
    
    init() {}
    
    func updateFavorites() {
        favoriteItems.removeAll()
        favorites.forEach({ favorite in
            favoriteItems.append(FavoriteItem(title: "\(NSLocalizedString("home.page.title", comment: "")) \(favorite)"))
        })
        refreshFavorites?()
    }
}

// MARK: User Actions

extension FavoritesViewModel {
    func loadComicDetails(atIndex index: Int) {
        let homeViewModel = HomeViewModel(withComicId: favorites[index], shouldAllowBrowsing: false)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        pushController?(homeViewController)
    }
}
