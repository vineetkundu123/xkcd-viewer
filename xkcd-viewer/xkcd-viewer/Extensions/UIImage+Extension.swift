import UIKit

extension UIImage {
    
    enum AppImages: String {
        case home_tab_active = "home-tab-active"
        case home_tab_inactive = "home-tab-inactive"

        case favorites_tab_active = "favorites-tab-active"
        case favorites_tab_inactive = "favorites-tab-inactive"

        case empty_star = "favorite-empty"
        case filled_star = "favorite-filled"
        
        case disclosure_indicator = "disclosure-indicator"
     }
    
    convenience init(appImage from: AppImages) {
        self.init(image: from)
    }
    
    private convenience init(image name: AppImages) {
        self.init(named: name.rawValue, in: nil, compatibleWith: nil)!
    }

}

extension UIImage {
    var original: UIImage {
        return self.withRenderingMode(.alwaysOriginal)
    }

    var template: UIImage {
        return self.withRenderingMode(.alwaysTemplate)
    }
}
