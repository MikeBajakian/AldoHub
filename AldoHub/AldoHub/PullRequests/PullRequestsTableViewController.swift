//
//  PullRequestsTableViewController.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-06.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire

class PullRequestsTableViewController: UITableViewController {

    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    var pullRequests:[PullRequestInfo]?
    var pullRequestsRepoName: String?
    var pullRequestsBranchName: String?

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ViewTitles.pullRequests
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //get the pull requests list
        getPullRequestsData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? PullRequestDetailsViewController,
                let pullRequestCell = sender as? PullRequestTableViewCell,
                    let pullRequestCellRow = tableView.indexPath(for: pullRequestCell)?.row
        else {
            return
        }
        
        // pass the pull request info to the details view
        destination.pullRequest = pullRequests?[pullRequestCellRow]
    }

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pullRequests?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.pullRequestCellIdentifier, for: indexPath) as? PullRequestTableViewCell  else {
            fatalError("PullRequestsTableViewController: cellForRowAtIndexPath: The dequeued cell is not an instance of PullRequestTableViewCell")
        }
        
        cell.cellPullRequest = pullRequests?[indexPath.row]
        
        return cell
    }
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - data
    func getPullRequestsData() {
        
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ConnectionManager.shared.oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        OAuth2ConnectionManager.shared.alamofireManager = sessionManager
        
        guard let connectedUserName = OAuth2ConnectionManager.shared.connectedUserName,
                let repoName = pullRequestsRepoName,
                    let branchName = pullRequestsBranchName
        else {
            return
        }
        
        //format the pullRequests request path correctly
        var requestPath = URLs.gitHubBranchPullRequestsGenericPath
        
        // insert the user name
        requestPath = requestPath.replacingOccurrences(of: GithubIdentifiers.userName, with: connectedUserName)
        // insert the repo name
        requestPath = requestPath.replacingOccurrences(of: GithubIdentifiers.repoName, with: repoName)
        // insert the branch name
        requestPath = requestPath.replacingOccurrences(of: GithubIdentifiers.branchName, with: branchName)
        
        sessionManager.request(requestPath).validate().responseJSON { response in
            
            guard let returnedData = response.data else {
                return
            }
            do {
                let returnedPullRequests = try JSONDecoder().decode([PullRequestInfo].self, from: returnedData)
                
                DispatchQueue.main.async {
                    self.pullRequests = returnedPullRequests
                    self.tableView.reloadData()
                }
            } catch let jsonDecoderError {
                print(jsonDecoderError)
            }
        }
    }
}



