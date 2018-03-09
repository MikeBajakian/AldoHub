//
//  PullRequestTableViewCell.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-06.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire

class PullRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var pullRequestStatusImageView: UIImageView!
    @IBOutlet weak var pullRequestStatusLabel: UILabel!
    @IBOutlet weak var pullRequestTitleLabel: UILabel!
    @IBOutlet weak var pullRequestNumberLabel: UILabel!    
    @IBOutlet weak var pullRequestBodyLabel: UILabel!
    
    
    
    var cellPullRequest: PullRequestInfo? {
        didSet {
            
            //pull request number
            if let number = cellPullRequest?.number {
                pullRequestNumberLabel.text = String(number)
            } else {
                pullRequestNumberLabel.text = ErrorMessages.noPullRequestNumber
            }
            
            //pull request title
            pullRequestTitleLabel.text = cellPullRequest?.title ?? ErrorMessages.noPullRequestTitle
            
            //pull request body
            pullRequestBodyLabel.text = cellPullRequest?.body ?? ErrorMessages.noPullRequestBody
 
            //pull request status
            
            //the pull request info returns the statuses URL so we have to fetch it in order to extract the last status
            if let statusesURL = cellPullRequest?.statuses_url, let url = URL(string: statusesURL + ConnectionManager.queryAppendClientIDAndSecret) {
                let loader = OAuth2DataLoader(oauth2: OAuth2ConnectionManager.shared.oauth2)
                loader.perform(request: URLRequest(url: url)) { response in
                    do {
                        let returnedData = try response.responseData()
                        let returnedStatusesArray = try JSONDecoder().decode([PullRequestStatusInfo].self, from: returnedData)
                        
                        DispatchQueue.main.async {
                            
                            if returnedStatusesArray.isEmpty {
                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Unknown)
                                self.pullRequestStatusLabel.text = ErrorMessages.noPullRequestStatus
                            }
                            else {
                                if let latestStatus = returnedStatusesArray.first,
                                    let latestStatusState = latestStatus.state { // we want the latest status which is the first element
                                        switch latestStatusState {
                                            case PullRequestStatusPossibleValues.error:
                                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Error)
                                                self.pullRequestStatusLabel.text = PullRequestStatusForUI_dictionary[PullRequestStatusPossibleValues.error]
                                                self.pullRequestStatusLabel.textColor = UIColor.black
                                            
                                            case PullRequestStatusPossibleValues.failure:
                                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Rejected)
                                                self.pullRequestStatusLabel.text = PullRequestStatusForUI_dictionary[PullRequestStatusPossibleValues.failure]
                                                self.pullRequestStatusLabel.textColor = UIColor.red

                                            case PullRequestStatusPossibleValues.pending:
                                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Pending)
                                                self.pullRequestStatusLabel.text = PullRequestStatusForUI_dictionary[PullRequestStatusPossibleValues.pending]
                                                self.pullRequestStatusLabel.textColor = UIColor.blue

                                            case PullRequestStatusPossibleValues.success:
                                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Approved)
                                                self.pullRequestStatusLabel.text = PullRequestStatusForUI_dictionary[PullRequestStatusPossibleValues.success]
                                                self.pullRequestStatusLabel.textColor = UIColor.green

                                            default:
                                                self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Unknown)
                                                self.pullRequestStatusLabel.text = ErrorMessages.noPullRequestStatus
                                                self.pullRequestStatusLabel.textColor = UIColor.black
                                        }
                                }
                            }
                        }
                    }
                    catch let jsonDecoderError {
                        print(jsonDecoderError)
                        self.pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Unknown)
                        self.pullRequestStatusLabel.text = ErrorMessages.noPullRequestStatus
                        self.pullRequestStatusLabel.textColor = UIColor.black
                    }
                }
            }
            else {
                pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Unknown)
                pullRequestStatusLabel.text = ErrorMessages.noPullRequestStatus
                pullRequestStatusLabel.textColor = UIColor.black
            }
        }
    }

    
    override func prepareForReuse() {
        pullRequestStatusImageView.image = UIImage(named: ImageNames.pullRequestStatus_Unknown)
        pullRequestStatusLabel.text = ""
        pullRequestStatusLabel.textColor = UIColor.black
        pullRequestTitleLabel.text = ""
        pullRequestNumberLabel.text = ""
        pullRequestBodyLabel.text = ""
    }
}






