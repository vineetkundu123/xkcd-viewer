import Foundation
import UIKit

class HomeViewModel {
    
    enum ActionType: Int {
        case next = 0
        case previous
        case first
        case last
    }
    
    private var apiManager = APIManager()
    private var comic: Comic? {
        didSet {
            fetchComicStrip()
        }
    }
    
    private var favorites: [String] {
        return UserDefaults.standard.getFavorites()
    }
    
    var title = NSLocalizedString("home.page.title", comment: "").replacingOccurrences(of: " #[comicNumber]", with: "")
    var nextButtonTitle = NSLocalizedString("next.button.title", comment: "")
    var previousButtonTitle = NSLocalizedString("previous.button.title", comment: "")
    var firstButtonTitle = NSLocalizedString("first.button.title", comment: "")
    var lastButtonTitle = NSLocalizedString("last.button.title", comment: "")
    var searchPlaceholder = NSLocalizedString("search.bar.placeholder", comment: "")

    var latestComicId: String = ""
    var currentComicId: String = ""
    
    var isFirstStrip: Bool = false
    var isLastStrip: Bool = true
    
    var allowBrowsing: Bool = true
    
    //Subscription methods: To be subscribed by view controller
    var updateTitle: ((_ title: String) -> Void)?
    var updateNavTitle: ((_ title: String) -> Void)?
    var updateBarButtonImage: ((_ image: UIImage) -> Void)?
    var updateImage: ((_ image: UIImage, _ loading: Bool) -> Void)?
    var updateButtonState: (() -> Void)?
    var pushController: ((UIViewController) -> Void)?
    var presentController: ((UIViewController) -> Void)?
    var loadSafariController: ((URL) -> Void)?
    
    init(withComicId comicId: String = "",
         shouldAllowBrowsing allowBrowsing: Bool = true) {
        self.currentComicId = comicId
        self.allowBrowsing = allowBrowsing
    }
    
    func showLoadingItems() {
        updateImage?(UIImage(), true)
    }
    
    func fetchData() {
        self.updateImage?(UIImage(), true)
        apiManager.fetchComic(withId: currentComicId, completion: {[weak self] comic, error in
            guard let self = self else { return }
            guard let comic = comic, error == nil else {
                //TODO: Handle error fetching comic strip here - may be show an error image
                self.updateImage?(UIImage(), false)
                return
            }
            self.comic = comic
            self.updateFlagsAndValues()
        })
    }
    
    private func fetchComicStrip() {
        if let comicStripUrl = comic?.img {
            apiManager.fetchComicStrip(fromUrl: comicStripUrl, completion: {[weak self] cover, error in
                guard let self = self else { return }
                    guard let imageData = cover, let image = UIImage(data: imageData), error == nil else {
                        //TODO: Handle error fetching comic strip here - may be show an error image
                        self.updateImage?(UIImage(), false)
                        return
                    }
                    self.updateImage?(image, false)
            })
        }
    }
    
    private func findComic(withText text: String) {
        self.updateImage?(UIImage(), true)
        apiManager.findComic(withSearchString: text, completion: {[weak self] comic, error in
            guard let self = self else { return }
            guard let comic = comic, error == nil else {
                //TODO: Handle error fetching comic strip here - may be show an error image
                self.updateImage?(UIImage(), false)
                return
            }
            self.comic = comic
            self.updateFlagsAndValues()
        })
    }
    
    private func updateFlagsAndValues() {
        guard let comic = comic else { return }
        self.currentComicId = String(comic.num?.toString() ?? "")
        if self.latestComicId.isEmpty {
            self.latestComicId = String(comic.num?.toString() ?? "")
        }
        
        self.title = "\(NSLocalizedString("home.page.title", comment: "")) \(String(comic.num?.toString() ?? ""))"
        
        self.updateNavTitle?(self.title)
        self.updateTitle?(comic.title ?? "")
        
        if self.favorites.contains(self.currentComicId) {
            self.updateBarButtonImage?(UIImage(appImage: .filled_star).original)
        } else {
            self.updateBarButtonImage?(UIImage(appImage: .empty_star).original)
        }
        
        self.updateButtonState?()
    }
}

// MARK: User Actions

extension HomeViewModel {
    func handleUserInteraction(withActionType actionType: ActionType?) {
        guard let type = actionType else {
            //TODO: Show error if necessary
            return
        }
        switch type {
        case .first:
            currentComicId = Constants.Comic.firstComicId
        case .last:
            currentComicId = latestComicId
        case .next:
            currentComicId = String((Int(currentComicId) ?? 0) + 1)
        case .previous:
            currentComicId = String((Int(currentComicId) ?? 2) - 1)
        }
        
        isFirstStrip = (currentComicId == Constants.Comic.firstComicId)
        isLastStrip = (currentComicId == latestComicId)
        
        fetchData()
    }
    
    func addOrRemoveFavorite() {
        var newFavorites = favorites
        if self.favorites.contains(currentComicId) {
            newFavorites.removeAll { $0 == currentComicId }
            self.updateBarButtonImage?(UIImage(appImage: .empty_star).original)
        } else {
            newFavorites.append(currentComicId)
            self.updateBarButtonImage?(UIImage(appImage: .filled_star).original)
        }
        UserDefaults.standard.setFavorites(newFavorites)
    }
    
    func loadExplanation() {
        if let url = URL(string: Constants.Comic.explanationURLPrefix + currentComicId) {
            loadSafariController?(url)
        }
    }
    
    func searchComic(withText text: String) {
        if let comicNumber = Int(text) {
            if comicNumber >= Int(Constants.Comic.firstComicId) ?? 1 && comicNumber <= Int(latestComicId) ?? 1 {
                currentComicId = text
                self.fetchData()
            } else {
                self.findComic(withText: text)
            }
        } else {
            self.findComic(withText: text)
        }
    }
}
