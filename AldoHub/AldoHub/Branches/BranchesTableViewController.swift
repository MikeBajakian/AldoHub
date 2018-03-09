//
//  BranchesTableViewController.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire


class BranchesTableViewController: UITableViewController {

    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    var branches:[BranchInfo]?
    var branchesRepoName: String?
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ViewTitles.branches
        
        //get the branches list
        getBranchData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? PullRequestsTableViewController,
                let branchCell = sender as? BranchTableViewCell,
                    let branchCellRow = tableView.indexPath(for: branchCell)?.row
        else {
            return
        }
        
        // pass the repo name and branch name to the pull requests
        destination.pullRequestsRepoName = branchesRepoName
        destination.pullRequestsBranchName = branches?[branchCellRow].name
    }

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return branches?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.branchCellIdentifier, for: indexPath) as? BranchTableViewCell  else {
            fatalError("BranchesTableViewController: cellForRowAtIndexPath: The dequeued cell is not an instance of BranchTableViewCell")
        }
        
        cell.cellBranch = branches?[indexPath.row]
        
        return cell
    }
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - data
    func getBranchData() {
        
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ConnectionManager.shared.oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        OAuth2ConnectionManager.shared.alamofireManager = sessionManager
        
        
        //format the branches request path correctly
        guard let connectedUserName = OAuth2ConnectionManager.shared.connectedUserName,
                let repoName = branchesRepoName
        else {
            return
        }
        
        var requestPath = URLs.gitHubRepoBranchesGenericPath
        // insert the user name
        requestPath = requestPath.replacingOccurrences(of: GithubIdentifiers.userName, with: connectedUserName)
        // insert the repo name
        requestPath = requestPath.replacingOccurrences(of: GithubIdentifiers.repoName, with: repoName)
                
        sessionManager.request(requestPath).validate().responseJSON { response in
            
            guard let returnedData = response.data else {
                return
            }
            do {
                let returnedBranches = try JSONDecoder().decode([BranchInfo].self, from: returnedData)
                
                DispatchQueue.main.async {
                    self.branches = returnedBranches
                    self.tableView.reloadData()
                }
            } catch let jsonDecoderError {
                print(jsonDecoderError)
            }
        }
    }
}
