//
//  AppDelegate.swift
//  xkcd-viewer
//
//  Created by Vineet Kundu on 20/09/2020.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        AppCommunicator.shared.initialiseApp()
        
        return true
    }
}
