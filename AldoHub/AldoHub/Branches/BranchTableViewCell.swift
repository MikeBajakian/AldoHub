//
//  BranchTableViewCell.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-05.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire


class BranchTableViewCell: UITableViewCell {

    @IBOutlet weak var branchNameLabel: UILabel!
    @IBOutlet weak var lastCommitSHALabel: UILabel!
    @IBOutlet weak var lastCommitMessageLabel: UILabel!
    

    struct CommitInfo: Codable {
        struct InnerCommit: Codable {
            let message: String?
        }
        let commit: InnerCommit?
    }

    
    
    var cellBranch: BranchInfo? {
        didSet {
            
            //branch name
            branchNameLabel.text = cellBranch?.name ?? ErrorMessages.noBranchName

            //branch last commit SHA
            lastCommitSHALabel.text = cellBranch?.commit?.sha ?? ErrorMessages.noBranchLastCommitSHA

            //branch last commit message
            //the commit info returns the URL of the commit so we have to fetch it in order to extract the commit message
            if let lastCommitURL = cellBranch?.commit?.url, let url = URL(string: lastCommitURL + ConnectionManager.queryAppendClientIDAndSecret) {
                let loader = OAuth2DataLoader(oauth2: OAuth2ConnectionManager.shared.oauth2)
                loader.perform(request: URLRequest(url: url)) { response in
                    do {
                        let returnedData = try response.responseData()
                        let returnedCommit = try JSONDecoder().decode(CommitInfo.self, from: returnedData)
                        
                        DispatchQueue.main.async {
                            self.lastCommitMessageLabel.text = returnedCommit.commit?.message
                        }
                    }
                    catch let jsonDecoderError {
                        print(jsonDecoderError)
                        self.lastCommitMessageLabel.text = ErrorMessages.noBranchLastCommitMessage
                    }
                }
            }
            else {
                lastCommitMessageLabel.text = ErrorMessages.noBranchLastCommitMessage
            }
        }
    }
    
    override func prepareForReuse() {
        branchNameLabel.text = ""
        lastCommitSHALabel.text = ""
        lastCommitMessageLabel.text = ""
    }
}


