//
//  LoginViewControllerTests.swift
//  AldoHubTests
//
//  Created by Mgrditch Bajakian on 2018-03-09.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import XCTest
import Foundation
@testable import AldoHub



class LoginViewControllerTests: XCTestCase {
    
    
    func test_LoginViewController_UpdateUI_NoUserLoggedIn() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.loginViewControllerIdentifier) as! LoginViewController
        let _ = loginViewController.view
        
        // test case when no user is logged in
        //   - login button title should be login
        loginViewController.isLoggedIn = false
        loginViewController.updateUI()
        let currentTitle = loginViewController.LoginLogoutButton.titleLabel?.text
        XCTAssert(currentTitle == ButtonTitles.login, "Invalid button title - login button when no user loggedIn --LoginVC--")
    }

    
    func test_LoginViewController_UpdateUI_UserLoggedIn_HasName() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.loginViewControllerIdentifier) as! LoginViewController
        let _ = loginViewController.view
        
        // test case when a user is logged in and has a name (obtained from their Github account)
        //   - login button title should be logout
        //   - salutation label should have user name
        let userName = "John Smith"
        loginViewController.isLoggedIn = true
        loginViewController.loggedInUserName = userName
        loginViewController.updateUI()
        let currentTitle = loginViewController.LoginLogoutButton.titleLabel?.text
        XCTAssert(currentTitle == ButtonTitles.logout, "Invalid button title - login button when user is loggedIn and has name --LoginVC--")

        let currentSalutation = loginViewController.SalutationLabel.text
        XCTAssert(currentSalutation == "\(MiscStrings.salutationPrefix) \(userName)", "Invalid salutation when loggedIn user has a name --LoginVC--")
    }

    
    func test_LoginViewController_UpdateUI_UserLoggedIn_HasNoName() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.loginViewControllerIdentifier) as! LoginViewController
        let _ = loginViewController.view
        
        // test case when a user is logged in but has no name (their Github account name field is blank)
        //   - login button title should be logout
        //   - salutation label should have default salutation
        let userName = ""
        loginViewController.isLoggedIn = true
        loginViewController.loggedInUserName = userName
        loginViewController.updateUI()
        let currentTitle = loginViewController.LoginLogoutButton.titleLabel?.text
        XCTAssert(currentTitle == ButtonTitles.logout, "Invalid button title - login button when user is loggedIn and has no name --LoginVC--")
        
        let currentSalutation = loginViewController.SalutationLabel.text
        XCTAssert(currentSalutation == "\(MiscStrings.salutationWelcome)", "Invalid salutation when loggedIn user has no name --LoginVC--")
    }
}














