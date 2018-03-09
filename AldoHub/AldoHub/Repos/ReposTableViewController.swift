//
//  ReposTableViewController.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire


class ReposTableViewController: UITableViewController {

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    var doneButton = UIBarButtonItem()
    var repos:[RepoInfo]?


    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ViewTitles.repositories
        //add done button
        doneButton = UIBarButtonItem(title: ButtonTitles.done, style: .plain, target: self, action: #selector(self.doneButtonTapped))
        self.navigationItem.leftBarButtonItem = doneButton
        
        //get the repos list
        getRepoData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? BranchesTableViewController,
                let repoCell = sender as? RepoTableViewCell,
                    let repoCellRow = tableView.indexPath(for: repoCell)?.row
        else {
            return
        }
        
        // pass the repo name to its branches
        destination.branchesRepoName = repos?[repoCellRow].name
    }
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: StoryboardIdentifiers.repoCellIdentifier, for: indexPath) as? RepoTableViewCell  else {
            fatalError("ReposTableViewController: cellForRowAtIndexPath: The dequeued cell is not an instance of RepoTableViewCell")
        }

        cell.cellRepo = repos?[indexPath.row]

        return cell
    }
    

    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - actions
    @objc func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - data
    func getRepoData() {
        
        let sessionManager = SessionManager()
        let retrier = OAuth2RetryHandler(oauth2: OAuth2ConnectionManager.shared.oauth2)
        sessionManager.adapter = retrier
        sessionManager.retrier = retrier
        OAuth2ConnectionManager.shared.alamofireManager = sessionManager

        sessionManager.request(URLs.gitHubUserReposPath).validate().responseJSON { response in
            
            guard let returnedData = response.data else {
                return
            }
            do {
                let returnedRepos = try JSONDecoder().decode([RepoInfo].self, from: returnedData)
                
                DispatchQueue.main.async {
                    self.repos = returnedRepos
                    self.tableView.reloadData()
                }
            } catch let jsonDecoderError {
                print(jsonDecoderError)
            }
        }
    }
}









