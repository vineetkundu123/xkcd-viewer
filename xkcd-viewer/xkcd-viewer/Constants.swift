import Foundation
import UIKit

enum AppMode {
    case mock
    case live
}

struct Constants {
    struct Network {
        static let timeOut = 10.0
    }
    
    struct Comic {
        static let firstComicId = "1"
        static let storageFileName = "comics"
        static let explanationURLPrefix = "https://www.explainxkcd.com/wiki/index.php/"
    }
    
    struct Mode {
        static var appMode: AppMode = .live
    }
}
