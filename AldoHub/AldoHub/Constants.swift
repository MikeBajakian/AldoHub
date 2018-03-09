//
//  Constants.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation


enum ImageNames {
    static let avatarPlaceHolder = "Placeholder"
    static let repoForked = "RepoForked"
    static let repoPrivate = "RepoPrivate"
    static let repoPublic = "RepoPublic"

    static let pullRequestStatus_Unknown = "PullRequest"
    static let pullRequestStatus_Error = "PullRequest_Error"
    static let pullRequestStatus_Pending = "PullRequest_Pending"
    static let pullRequestStatus_Approved = "PullRequest_Approved"
    static let pullRequestStatus_Rejected = "PullRequest_Rejected"

}


enum ButtonTitles {
    static let login = "Login"
    static let loggingIn = "Logging In..."
    static let logout = "Logout"
    static let done = "Done"
}


enum ViewTitles {
    static let repositories = "Repositories"
    static let branches = "Branches"
    static let pullRequests = "Pull Requests"
    static let pullRequest = "Pull Request"
}


enum MiscStrings {
    static let salutationPrefix = "Hi"
    static let salutationWelcome = "Welcome to AldoHub"
}


enum StoryboardIdentifiers {
    static let mainStoryboardName = "Main"
    static let launchScreenStoryboardName = "LaunchScreen"

    static let loginViewControllerIdentifier = "loginViewControllerIdentifier"
    static let reposTableViewControllerIdentifier = "reposTableViewControllerIdentifier"
    static let branchesTableViewControllerIdentifier = "branchesTableViewControllerIdentifier"
    static let pullRequestsTableViewControllerIdentifier = "pullRequestsTableViewControllerIdentifier"
    static let pullRequestDetailsViewControllerIdentifier = "pullRequestDetailsViewControllerIdentifier"

    static let repoCellIdentifier = "repoCellIdentifier"
    static let branchCellIdentifier = "branchCellIdentifier"
    static let pullRequestCellIdentifier = "pullRequestCellIdentifier"
}


enum GithubKeys {
    static let name = "name"
    static let avatarURL = "avatar_url"
    static let user = "login"
}


enum ConnectionManager {
    //To avaoid reaching access rate limits set by Github (60 calls/hr) add the client id and secret to request URL
    static let queryAppendClientIDAndSecret = "?client_id=8ae913c685556e73a16f&client_secret=60d81efcc5293fd1d096854f4eee0764edb2da5d"
}


enum GithubIdentifiers {
    static let userName = ":owner"
    static let repoName = ":repo"
    static let branchName = ":branch"
}


enum URLs {
    static let gitHubUserPath = "https://api.github.com/user"
    static let gitHubUserReposPath = "https://api.github.com/user/repos"
    static let gitHubRepoBranchesGenericPath = "https://api.github.com/repos/:owner/:repo/branches"
    static let gitHubBranchPullRequestsGenericPath = "https://api.github.com/repos/:owner/:repo/pulls?base=:branch&state=all"
}


enum ErrorMessages {
    static let noRepoName = "Repo name not available"
    static let noBranchName = "Branch name not available"
    static let noBranchLastCommitSHA = "Last commit SHA not available"
    static let noBranchLastCommitMessage = "Last commit message not available"
    
    static let noPullRequestNumber = "Pull request number not available"
    static let noPullRequestTitle = "Pull request title not available"
    static let noPullRequestBody = "Pull request message not available"
    static let noPullRequestStatus = "No Status"
}

//----------------------------------------------------------------------------------
// Pull request Status-related
//----------------------------------------------------------------------------------
//documentation: https://developer.github.com/v3/repos/statuses/#create-a-status
enum PullRequestStatusPossibleValues: String {
    static let error = "error"
    static let failure = "failure"
    static let pending = "pending"
    static let success = "success"
    
    case errorValue = "error"
    case failureValue = "failure"
    case pendingValue = "pending"
    case successValue = "success"
}

enum PullRequestStatusPUSH_Parameters {
    static let state = "state"
    static let target_url = "target_url"
    static let description = "description"
    static let context = "context"
}

let PullRequestStatusForUI_dictionary = [
    "error" : "Error",
    "failure" : "Rejected",
    "pending" : "Pending",
    "success" : "Approved"
]
//----------------------------------------------------------------------------------


enum statusButtonsTagValues: Int {
    case Approve = 100
    case Reject = 200
    case Pending = 300
}


enum APIRequestPossibleResults: String {
    case failure = "failure"
    case success = "success"
}


enum FeedbackMessages {
    static let failure = "Posting new status failed!"
    static let success = "Posting new status was successful!"
}











































