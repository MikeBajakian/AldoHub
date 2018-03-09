//
//  Branch.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-05.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation

//Documentation https://api.github.com/repos/:owner/:repo/branches

struct BranchInfo: Codable {
    
    struct LastCommit: Codable {
        let sha: String?
        let url: String? // == last commit url (which will be used to get the last commit message)
    }

    let name: String?
    let commit: LastCommit?
}

