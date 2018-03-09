//
//  ViewControllerLoadingTests.swift
//  AldoHubTests
//
//  Created by Mgrditch Bajakian on 2018-03-09.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import XCTest
import Foundation
@testable import AldoHub



class ViewControllerLoadingTests: XCTestCase {
    
    
    //Login
    func test_ViewControllerLoading_Login() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        XCTAssertNotNil(storyBoard, "Could not instantiate storyboard to load -- LoginVC --")
        
        guard let _ = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.loginViewControllerIdentifier) as? LoginViewController else {
            XCTAssert(false, "Could not instaniate view controller for -- LoginVC --")
            return
        }
    }
    
    
    //Repos
    func test_TableViewControllerLoading_Repos() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        XCTAssertNotNil(storyBoard, "Could not instantiate storyboard to load -- ReposTVC --")
        
        guard let _ = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.reposTableViewControllerIdentifier) as? ReposTableViewController else {
            XCTAssert(false, "Could not instaniate table view controller for -- ReposTVC --")
            return
        }
    }


    //Branches
    func test_TableViewControllerLoading_Branches() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        XCTAssertNotNil(storyBoard, "Could not instantiate storyboard to load -- BranchesTVC --")
        
        guard let _ = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.branchesTableViewControllerIdentifier) as? BranchesTableViewController else {
            XCTAssert(false, "Could not instaniate table view controller for -- BranchesTVC --")
            return
        }
    }
    
    
    //Pull requests
    func test_TableViewControllerLoading_PullRequests() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        XCTAssertNotNil(storyBoard, "Could not instantiate storyboard to load -- PullRequestsTVC --")
        
        guard let _ = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.pullRequestsTableViewControllerIdentifier) as? PullRequestsTableViewController else {
            XCTAssert(false, "Could not instaniate table view controller for -- PullRequestsTVC --")
            return
        }
    }
    
    
    //Pull request details
    func test_ViewControllerLoading_PullRequestDetails() {
        
        let storyBoard = UIStoryboard(name: StoryboardIdentifiers.mainStoryboardName, bundle: nil)
        XCTAssertNotNil(storyBoard, "Could not instantiate storyboard to load -- PullRequestDetailsVC --")
        
        guard let _ = storyBoard.instantiateViewController(withIdentifier: StoryboardIdentifiers.pullRequestDetailsViewControllerIdentifier) as? PullRequestDetailsViewController else {
            XCTAssert(false, "Could not instaniate table view controller for -- PullRequestDetailsVC --")
            return
        }
    }
}









