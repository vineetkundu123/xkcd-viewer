import Foundation
import UIKit

class HomeViewModel {
    
    enum ActionType: Int {
        case next = 0
        case previous
        case first
        case last
    }
    
    private let comicStorageService = StorageService(fileName: Constants.Comic.storageFileName)
    
    private var apiManager: APIManager
    private var comic: Comic?
    
    private var favoriteComics: [Comic]?
    
    var title = ""
    var nextButtonTitle = NSLocalizedString("next.button.title", comment: "")
    var previousButtonTitle = NSLocalizedString("previous.button.title", comment: "")
    var firstButtonTitle = NSLocalizedString("first.button.title", comment: "")
    var lastButtonTitle = NSLocalizedString("last.button.title", comment: "")
    var searchPlaceholder = NSLocalizedString("search.bar.placeholder", comment: "")

    var latestComicId: String = ""
    var currentComicId: String
    
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
         shouldAllowBrowsing allowBrowsing: Bool = true,
         withAPIManager apiManager: APIManager = APIManager()) {
        self.currentComicId = comicId
        self.allowBrowsing = allowBrowsing
        self.apiManager = apiManager
        self.favoriteComics = comicStorageService.fetch()
    }
    
    func showLoadingItems() {
        updateImage?(UIImage(), true)
    }
    
    func fetchData() {
        if let favoriteComic = favoriteComics?.first(where: {$0.num?.toString() == currentComicId}) {
            //If comic is stored use the stored comic
            self.comic = favoriteComic
            self.updateFlagsAndValues()
        } else {
            self.updateImage?(UIImage(), true)
            apiManager.fetchComic(withId: currentComicId, completion: {[weak self] comic, error in
                guard let self = self else { return }
                guard let comic = comic, error == nil else {
                    //TODO: Handle error fetching comic strip here - may be show an error image
                    self.comic = nil
                    self.updateImage?(UIImage(), false)
                    self.updateTitle?("")
                    self.updateNavTitle?("")
                    return
                }
                self.comic = comic
                self.updateFlagsAndValues()
                self.fetchComicStrip()
            })
        }
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
                self.comic?.imageData = image.pngData()
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
        
        //Update nav title
        self.title = "\(NSLocalizedString("home.page.title", comment: "")) \(currentComicId)"
        self.updateNavTitle?(self.title)

        //Update image
        if let imageData = self.comic?.imageData {
            self.updateImage?(UIImage(data: imageData) ?? UIImage(), false)
        } else {
            self.fetchComicStrip()
        }
        
        //Update title
        self.updateTitle?(comic.title ?? "")
        
        //Manage Favorite icon
        if self.favoriteComics?.contains(where: {$0.num?.toString() == currentComicId}) ?? false {
            self.updateBarButtonImage?(UIImage(appImage: .filled_star).original)
        } else {
            self.updateBarButtonImage?(UIImage(appImage: .empty_star).original)
        }
        
        //Update next/previous/first/last button states
        updateNavigationState()
        self.updateButtonState?()
    }
    
    private func updateNavigationState() {
        isFirstStrip = (currentComicId == Constants.Comic.firstComicId)
        isLastStrip = (currentComicId == latestComicId)
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
        
        updateNavigationState()
        fetchData()
    }
    
    func addOrRemoveFavorite() {
        if let comicIndex = self.favoriteComics?.firstIndex(where: {$0.num?.toString() == currentComicId}) {
            //Remove favorite
            favoriteComics?.remove(at: comicIndex)
            self.updateBarButtonImage?(UIImage(appImage: .empty_star).original)
        } else {
            if let currentComic = comic {
                //Initialise favorites if empty
                if favoriteComics == nil {
                    favoriteComics = []
                }
                //Add a new favorite
                favoriteComics?.append(currentComic)
                self.updateBarButtonImage?(UIImage(appImage: .filled_star).original)
            }
        }
        
        //Save preferences locally
        comicStorageService.save(object: favoriteComics)
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
