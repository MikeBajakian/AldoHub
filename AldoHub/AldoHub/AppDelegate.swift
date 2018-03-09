//
//  AppDelegate.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        Thread.sleep(forTimeInterval: 1.8)// Sorry for the hack but I wanted to make sure you guys see the LaunchScreen
        return true
    }

    //This method is used form the third party P2/OAuth2 to handle re-directs during login-phase
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if "ppoauthapp" == url.scheme || (url.scheme?.hasPrefix("com.googleusercontent.apps"))! {
            if let _ = window?.rootViewController as? LoginViewController {
                //vc.oauth2.handleRedirectURL(url)
                OAuth2ConnectionManager.shared.oauth2.handleRedirectURL(url)
                return true
            }
        }
        return false
    }
}

