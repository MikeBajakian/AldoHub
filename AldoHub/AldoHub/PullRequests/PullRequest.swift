//
//  PullRequest.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-06.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation

//Documentation https://api.github.com/repos/:owner/:repo/pulls?base=:branch&state=all

struct PullRequestInfo: Codable {
    
    let number: Int?
    let title: String?
    let body: String?
    let statuses_url: String?
}


struct PullRequestStatusInfo: Codable {
    
    let state: String?
    let description: String?
    let target_url: String?
    let context: String?
}

