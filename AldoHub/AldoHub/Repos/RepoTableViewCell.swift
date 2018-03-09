//
//  RepoTableViewCell.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2

class RepoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var repoAvatarImageView: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var repoAccessLevelImageView: UIImageView!
    @IBOutlet weak var repoIsForkedImageView: UIImageView!
    
    
    var cellRepo: RepoInfo? {
        didSet {
            //set the image from its avatar url
            repoAvatarImageView.setRounded()
            
            if let avatar_url = cellRepo?.owner?.avatar_url, let url = URL(string: avatar_url + ConnectionManager.queryAppendClientIDAndSecret) {
                let loader = OAuth2DataLoader(oauth2: OAuth2ConnectionManager.shared.oauth2)
                loader.perform(request: URLRequest(url: url)) { response in
                    do {
                        let data = try response.responseData()
                        DispatchQueue.main.async {
                            self.repoAvatarImageView.image = UIImage(data: data)
                        }
                    }
                    catch let error {
                        print("Failed to load avatar: \(error)")
                        self.repoAvatarImageView.image = UIImage(named: ImageNames.avatarPlaceHolder)
                    }
                }
            }
            else {
                repoAvatarImageView.image = UIImage(named: ImageNames.avatarPlaceHolder)
            }
            
            //repo name
            repoNameLabel.text = cellRepo?.name ?? ErrorMessages.noRepoName
            
            //repo access level: private or public
            if let repoIsPrivate = cellRepo?.private {
                repoAccessLevelImageView.image = UIImage(named: repoIsPrivate ? ImageNames.repoPrivate : ImageNames.repoPublic)
                repoAccessLevelImageView.isHidden = false
            }
            else {
                repoAccessLevelImageView.isHidden = true
            }
            
            //repo is forked?
            if let repoIsForked = cellRepo?.fork {
                repoIsForkedImageView.isHidden = !repoIsForked
            }
            else {
                repoIsForkedImageView.isHidden = true
            }
        }
    }
    
    override func prepareForReuse() {
        repoAvatarImageView.image = UIImage(named: ImageNames.avatarPlaceHolder)
        repoNameLabel.text = ""
        repoAccessLevelImageView.isHidden = true
        repoIsForkedImageView.isHidden = true
    }
}
