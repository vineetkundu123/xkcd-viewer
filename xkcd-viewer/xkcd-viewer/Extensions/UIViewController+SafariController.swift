import Foundation
import UIKit
import SafariServices

extension UIViewController {
    func loadSafariController(withUrl url: URL,
                              withBarTintColor barTintColor: UIColor = .white,
                              withControlTintColor controlTintColor: UIColor = .darkGray) {
        DispatchQueue.main.async {
            URLCache.shared.removeAllCachedResponses()
            if let cookies = HTTPCookieStorage.shared.cookies {
                for cookie in cookies {
                    HTTPCookieStorage.shared.deleteCookie(cookie)
                }
            }

            let safariViewController: SFSafariViewController = {
                if #available(iOS 11.0, *) {
                    let configuration = SFSafariViewController.Configuration()
                    configuration.barCollapsingEnabled = true
                    configuration.entersReaderIfAvailable = false
                    let safariViewController = SFSafariViewController(url: url, configuration: configuration)
                    safariViewController.dismissButtonStyle = .close
                    return safariViewController
                } else {
                    return SFSafariViewController(url: url, entersReaderIfAvailable: false)
                }
            }()
            safariViewController.preferredBarTintColor = barTintColor
            safariViewController.preferredControlTintColor = controlTintColor
            self.present(safariViewController, animated: true, completion: nil)
        }
    }
}
