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
    
    var title = NSLocalizedString("home.page.title", comment: "").replacingOccurrences(of: " #[comicNumber]", with: "")
    var nextButtonTitle = NSLocalizedString("next.button.title", comment: "")
    var previousButtonTitle = NSLocalizedString("previous.button.title", comment: "")
    var firstButtonTitle = NSLocalizedString("first.button.title", comment: "")
    var lastButtonTitle = NSLocalizedString("last.button.title", comment: "")

    var latestComicId: String = ""
    var currentComicId: String = ""
    
    var isFirstStrip: Bool = false
    var isLastStrip: Bool = true
    
    //Subscription methods: To be subscribed by view controller
    var updateTitle: ((_ title: String) -> Void)?
    var updateNavTitle: ((_ title: String) -> Void)?
    var updateImage: ((_ image: UIImage, _ loading: Bool) -> Void)?
    var updateButtonState: (() -> Void)?
    var pushController: ((UIViewController) -> Void)?
    var presentController: ((UIViewController) -> Void)?
    
    init() {}
    
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
    
    private func searchComic() {
        if let comicStripUrl = comic?.img {
            apiManager.fetchComicStrip(fromUrl: comicStripUrl, completion: {[weak self] cover, error in
                guard let self = self else { return }
                    guard let imageData = cover, let image = UIImage(data: imageData), error == nil else {
                        //TODO: Handle error fetching searched comic here
                        return
                    }
                    self.updateImage?(image, false)
            })
        }
    }
    
    private func updateFlagsAndValues() {
        guard let comic = comic else { return }
        self.currentComicId = String(comic.num?.toString() ?? "")
        if self.latestComicId.isEmpty {
            self.latestComicId = String(comic.num?.toString() ?? "")
        }
        
        self.title = NSLocalizedString("home.page.title", comment: "")
            .replacingOccurrences(of: "[comicNumber]", with: String(comic.num?.toString() ?? ""))
        
        self.updateNavTitle?(self.title)
        self.updateTitle?(comic.title ?? "")
        
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
}
