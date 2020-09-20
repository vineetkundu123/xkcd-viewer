import UIKit

class GenericTabbarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.tintColor = UIColor.clear
        tabBar.unselectedItemTintColor = .gray
        setTabbarItmes()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    func setTabbarItmes() {
        // Home Tab
        let homeViewController = HomeViewController(viewModel: HomeViewModel())
        homeViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("home.tab.title", comment: ""),
                                                     image: UIImage(appImage: .home_tab_inactive).original,
                                                     selectedImage: UIImage(appImage: .home_tab_active).original)
        let homeTab = UINavigationController(rootViewController: homeViewController)
        
        // Favorites Tab
        let favoritesViewController = FavoritesViewController(viewModel: FavoritesViewModel())
        favoritesViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("favorites.tab.title", comment: ""),
                                                          image: UIImage(appImage: .favorites_tab_inactive).original,
                                                          selectedImage: UIImage(appImage: .favorites_tab_active).original)
        let favoritesTab = UINavigationController(rootViewController: favoritesViewController)
        
        viewControllers = [homeTab, favoritesTab]
        
        let colorSelected: UIColor = UIColor.darkText
        let titleFontAll: UIFont = UIFont.systemFont(ofSize: 10.0)
        
        let attributesSelected = [
            NSAttributedString.Key.foregroundColor: colorSelected,
            NSAttributedString.Key.font: titleFontAll
        ]

        UITabBarItem.appearance().setTitleTextAttributes(attributesSelected, for: .selected)
    }
}
