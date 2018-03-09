//
//  Repo.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation

//Documentation https://api.github.com/user/repos

struct RepoInfo: Codable {

    struct Owner: Codable {
        let avatar_url: String?
    }
    
    let name: String?
    let owner: Owner?
    let fork: Bool?
    let `private`: Bool?  //have to escape swift keyword to be able to use it as variable name
}

