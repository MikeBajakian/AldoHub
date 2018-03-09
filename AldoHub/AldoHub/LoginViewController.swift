//
//  LoginViewController.swift
//  AldoHub
//
//  Created by Mgrditch Bajakian on 2018-03-04.
//  Copyright © 2018 Mike Bajakian. All rights reserved.
//

import UIKit
import p2_OAuth2



class LoginViewController: UIViewController {

    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - outlets
    @IBOutlet weak var AvatarImage: UIImageView! {
        didSet {
            AvatarImage.setRounded()
        }
    }
    @IBOutlet weak var SalutationLabel: UILabel!
    @IBOutlet weak var ReposButton: UIButton!
    @IBOutlet weak var LoginLogoutButton: UIButton!
    

    
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - properties
    var isLoggedIn: Bool = false
    var loggedInUserName: String = ""

    var loader: OAuth2DataLoader?
    
    var userDataRequest: URLRequest {
        let finalString = URLs.gitHubUserPath +  ConnectionManager.queryAppendClientIDAndSecret
        var request = URLRequest(url: URL(string: finalString)!)
        request.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "Accept")
        return request
    }

    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - view lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }

    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - actions
    @IBAction func doLoginOrLogout(_ sender: UIButton) {

        if isLoggedIn {
            OAuth2ConnectionManager.shared.oauth2.forgetTokens()
            let storage = HTTPCookieStorage.shared
            storage.cookies?.forEach() {
                storage.deleteCookie($0)
            }
            isLoggedIn = false
            updateUI()
        }
        else {
            if OAuth2ConnectionManager.shared.oauth2.isAuthorizing {
                OAuth2ConnectionManager.shared.oauth2.abortAuthorization()
                isLoggedIn = false
                updateUI()
                return
            }
            
            sender.setTitle(ButtonTitles.loggingIn, for: UIControlState.normal)
            OAuth2ConnectionManager.shared.oauth2.authConfig.authorizeEmbedded = true
            OAuth2ConnectionManager.shared.oauth2.authConfig.authorizeContext = self
            let loader = OAuth2DataLoader(oauth2: OAuth2ConnectionManager.shared.oauth2)
            self.loader = loader
            
            loader.perform(request: userDataRequest) { response in
                do {
                    let json = try response.responseJSON()
                    self.didGetUserdata(dict: json, loader: loader)
                }
                catch let error {
                    self.didCancelOrFail(error)
                }
            }
        }
    }
    
    
    //-----------------------------------------------------------------------------------------------------------------
    // MARK: - methods
    func didGetUserdata(dict: [String: Any], loader: OAuth2DataLoader?) {
        DispatchQueue.main.async {
            if let username = dict[GithubKeys.name] as? String {
                self.loggedInUserName = username
                //save the Github user name for future fetches
                if let connectedUserName = dict[GithubKeys.user] as? String {
                    OAuth2ConnectionManager.shared.connectedUserName = connectedUserName
                }
            }
            else {
                self.loggedInUserName = ""
            }
            if let imgURL = dict[GithubKeys.avatarURL] as? String, let url = URL(string: imgURL) {
                self.loadUserAvatar(from: url, with: loader)
            }
            self.isLoggedIn = true
            self.updateUI()
        }
    }

    
    func didCancelOrFail(_ error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Authorization went wrong: \(error)")
            }
            self.isLoggedIn = false
            self.updateUI()
        }
    }

    
    func loadUserAvatar(from url: URL, with loader: OAuth2DataLoader?) {
        if let loader = loader {
            loader.perform(request: URLRequest(url: url)) { response in
                do {
                    let data = try response.responseData()
                    DispatchQueue.main.async {
                        self.AvatarImage?.image = UIImage(data: data)
                    }
                }
                catch let error {
                    print("Failed to load avatar: \(error)")
                    self.AvatarImage?.image = UIImage(named: ImageNames.avatarPlaceHolder)
                }
            }
        }
        else {
            self.AvatarImage?.image = UIImage(named: ImageNames.avatarPlaceHolder)
        }
    }

    
    func updateUI() {
        if isLoggedIn {
            SalutationLabel.text = loggedInUserName.isEmpty ? MiscStrings.salutationWelcome : "\(MiscStrings.salutationPrefix) \(loggedInUserName)"
            ReposButton.isHidden = false
            LoginLogoutButton.setTitle(ButtonTitles.logout, for: .normal)
        }
        else {
            AvatarImage.image = UIImage(named: ImageNames.avatarPlaceHolder)
            SalutationLabel.text = MiscStrings.salutationWelcome
            ReposButton.isHidden = true
            LoginLogoutButton.setTitle(ButtonTitles.login, for: .normal)
        }
    }
}



