import Foundation
import UIKit

class AppCommunicator {
    static let shared = AppCommunicator()
    public var mainWindow: UIWindow
    
    private init() {
        mainWindow = UIWindow(frame: UIScreen.main.bounds)
    }
    
    func initialiseApp() {
        //Perform any operations before loading initial page here
        loadInitialPage()
    }
    
    //Load Initial Page
    private func loadInitialPage() {
       let genericTabBarController = GenericTabbarViewController()
       mainWindow.rootViewController = genericTabBarController
       mainWindow.makeKeyAndVisible()
    }
}
