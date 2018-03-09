//
//  OAuth2ConnectionManager.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-05.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import Foundation
import p2_OAuth2
import Alamofire



final class OAuth2ConnectionManager {
    
    // The below Client-ID and Secret are from the sample project in public Github Repo for p2/OAuth2
    //https://github.com/p2/OAuth2
    
    var oauth2 = OAuth2CodeGrant(settings: [
        "client_id": "8ae913c685556e73a16f",
        "client_secret": "60d81efcc5293fd1d096854f4eee0764edb2da5d",
        "authorize_uri": "https://github.com/login/oauth/authorize",
        "token_uri": "https://github.com/login/oauth/access_token",
        "scope": "user repo:status",
        "redirect_uris": ["ppoauthapp://oauth/callback"],
        "secret_in_body": true,
        "verbose": true,
        ] as OAuth2JSON)

    //fileprivate var alamofireManager: SessionManager?
    var alamofireManager: SessionManager?
    
    var connectedUserName: String?
    

    static let shared = OAuth2ConnectionManager()

}

