//
//  PullRequestDetailsViewController.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-08.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2
import Alamofire

class PullRequestDetailsViewController: UIViewController {

    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - outlets
    @IBOutlet weak var pullRequestStatusImageView: UIImageView!
    @IBOutlet weak var pullRequestStatusLabel: UILabel!
    @IBOutlet weak var pullRequestTitleLabel: UILabel!
    @IBOutlet weak var pullRequestNumberLabel: UILabel!
    @IBOutlet weak var pullRequestBodyLabel: UILabel!
    
    @IBOutlet weak var postNewStatus_ApproveButton: UIButton!
    @IBOutlet weak var postNewStatus_RejectButton: UIButton!
    @IBOutlet weak var postNewStatus_PendingButton: UIButton!
    
    @IBOutlet weak var postNewStatus_FeedbackLabel: UILabel!
    
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    var pullRequest:PullRequestInfo?

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = ViewTitles.pullRequest
        
        fillPullRequestDetails()
    }

    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - button actions

    @IBAction func doPostNewStatus(_ sender: UIButton) {

        // each button (Approve, Reject, Pending) has a specific tag
        if let buttonTagValue = statusButtonsTagValues(rawValue: sender.tag) {
        
            var stateParameter: String = ""
        
            switch buttonTagValue {
                case statusButtonsTagValues.Approve:
                    stateParameter = PullRequestStatusPossibleValues.success
                case statusButtonsTagValues.Reject:
                    stateParameter = PullRequestStatusPossibleValues.failure
                case statusButtonsTagValues.Pending:
                    stateParameter = PullRequestStatusPossibleValues.pending
            }
            
            if stateParameter.isEmpty {
                print("Could not set a valid state. Check button tag value.")
                return
            }
            
            guard let pullRequestStatuses_url = pullRequest?.statuses_url else {
                return
            }
            
            // PUSH the new status
            let sessionManager = SessionManager()
            let retrier = OAuth2RetryHandler(oauth2: OAuth2ConnectionManager.shared.oauth2)
            sessionManager.adapter = retrier
            sessionManager.retrier = retrier
            OAuth2ConnectionManager.shared.alamofireManager = sessionManager
            
            //prepare the parameters needed for the PUSH request
            let parameters = [
                PullRequestStatusPUSH_Parameters.state : stateParameter, // this is the new status to be PUSH-ed
                PullRequestStatusPUSH_Parameters.target_url: "http://www.aldogroup.com",
                PullRequestStatusPUSH_Parameters.description: "Testing AldoHub iOS app",
                PullRequestStatusPUSH_Parameters.context: "Status changed from AldoHub Github-client iOS TEST app"
            ]
            
            sessionManager.request(pullRequestStatuses_url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: nil).validate().responseJSON { response in
                
                switch response.result {
                    case .success:
                        self.update_StatusUIFor(Status: stateParameter)
                        self.update_PostNewStatusButtonsFor(Status: PullRequestStatusPossibleValues(rawValue: stateParameter)!)
                        self.showFeedback_ForPostNewStatusWith(Result: .success)
                    
                    case .failure(let error):
                        self.showFeedback_ForPostNewStatusWith(Result: .failure)
                        print(error)
                }
            }
        } else {
            print("Button has no tag value. Check the storyboard")
       }
    }

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - UI
    func update_StatusUIFor(Status: String) {
        switch Status {
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
    
    
    // according to the current status, update the "Post new status" buttons to only allow posting another status
    // ex: if current status is Approved then Approved button is disabled so you can only Reject or Pending
    func update_PostNewStatusButtonsFor(Status: PullRequestStatusPossibleValues) {
        switch Status {
            case .errorValue:
                postNewStatus_ApproveButton.isEnabled = true
                postNewStatus_RejectButton.isEnabled = true
                postNewStatus_PendingButton.isEnabled = true
            case .failureValue:
                postNewStatus_ApproveButton.isEnabled = true
                postNewStatus_RejectButton.isEnabled = false
                postNewStatus_PendingButton.isEnabled = true
            case .pendingValue:
                postNewStatus_ApproveButton.isEnabled = true
                postNewStatus_RejectButton.isEnabled = true
                postNewStatus_PendingButton.isEnabled = false
            case .successValue:
                postNewStatus_ApproveButton.isEnabled = false
                postNewStatus_RejectButton.isEnabled = true
                postNewStatus_PendingButton.isEnabled = true
        }
    }
    
    
    func showFeedback_ForPostNewStatusWith(Result: APIRequestPossibleResults) {
        
        var color:UIColor
        var message: String
        
        switch Result {
            case .failure:
                color = UIColor.red
                message = FeedbackMessages.failure
            case .success:
                color = UIColor.green
                message = FeedbackMessages.success
        }
        
        postNewStatus_FeedbackLabel.textColor = color
        postNewStatus_FeedbackLabel.text = message
        postNewStatus_FeedbackLabel.isHidden = false
        postNewStatus_FeedbackLabel.alpha = 0

        UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.postNewStatus_FeedbackLabel.alpha = 1.0
        }, completion: { (finished: Bool) -> Void in
            UIView.animate(withDuration: 2.5, animations: {
                self.postNewStatus_FeedbackLabel.alpha = 0.0
            }, completion: { (finished: Bool) -> Void in
                self.postNewStatus_FeedbackLabel.isHidden = true
            })
        })
    }

    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - data
    func fillPullRequestDetails() {

        //pull request number
        if let number = pullRequest?.number {
            pullRequestNumberLabel.text = String(number)
        } else {
            pullRequestNumberLabel.text = ErrorMessages.noPullRequestNumber
        }

        //pull request title
        pullRequestTitleLabel.text = pullRequest?.title ?? ErrorMessages.noPullRequestTitle
        
        //pull request body
        pullRequestBodyLabel.text = pullRequest?.body ?? ErrorMessages.noPullRequestBody

        //pull request status
        //the pull request info returns the statuses URL so we have to fetch it in order to extract the last status
        if let statusesURL = pullRequest?.statuses_url, let url = URL(string: statusesURL + ConnectionManager.queryAppendClientIDAndSecret) {
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
                            if let latestStatusInfo = returnedStatusesArray.first, // we want the latest status info which is in the first element
                                let latestStatusState = latestStatusInfo.state {
                                
                                self.update_StatusUIFor(Status: latestStatusState)
                                
                                // update button states
                                if let latestStatusStringValue = PullRequestStatusPossibleValues(rawValue: latestStatusState) {
                                    self.update_PostNewStatusButtonsFor(Status: latestStatusStringValue)
                                } else {
                                    self.update_PostNewStatusButtonsFor(Status: .errorValue)
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
