import XCTest
@testable import xkcd_viewer

class FavoritesViewModelTests: XCTestCase {
    
    // MARK: - Setup
    
    var viewModel: FavoritesViewModel!
    let storageService: StorageService = StorageService(fileName: Constants.Comic.storageFileName)

    override func setUpWithError() throws {
        Constants.Mode.appMode = .mock
        viewModel = FavoritesViewModel()
    }
    
    override func tearDownWithError() throws {
        viewModel = nil
    }
    
    // MARK: - Tests
    
    func test_Update_Favorites() {
        XCTAssertTrue(viewModel.favoriteItems.isEmpty)
        var favorites: [Comic]? = storageService.fetch()
        
        viewModel.updateFavorites()

        XCTAssertEqual(viewModel.favoriteItems.count, favorites?.count)
        favorites?.append(Comic(num: 4000, day: nil, month: nil, year: nil, title: nil, alt: nil, img: nil, imageData: nil))
        storageService.save(object: favorites)
        viewModel.updateFavorites()
        XCTAssertEqual(viewModel.favoriteItems.count, favorites?.count)

        favorites = favorites?.dropLast()
        storageService.save(object: favorites)
        viewModel.updateFavorites()

        XCTAssertEqual(viewModel.favoriteItems.count, favorites?.count)
    }
}
