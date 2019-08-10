//
//  UserDetailsViewModel.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation
import TwitterKit

class UserDetailsViewModel {
    
    var reloadTableViewClosure: ((_ success: Bool)->())?
    var showErrorAlertClosure: ((_ error: String?)->())?
    var users: [User] = []
    
    var selectedIndex:Int = -1 {
        didSet {
            switch selectedIndex {
            case 0:
                self.fetchFollowers()
                break
            case 1:
                self.fetchFollowing()
                break
            default: break
            }
            self.reloadTableViewClosure?(true)
        }
    }
    
    var followerUsers: [User]? = []
    var followingUsers: [User]? = []

    var errorMeesage: String? {
        didSet {
            self.showErrorAlertClosure?(errorMeesage)
        }
    }
    
    var followerModel: [User] = [] {
        didSet {
            self.reloadTableViewClosure?(true)
            self.followerUsers = followerModel
        }
    }
    
    var followingModel: [User] = [] {
        didSet {
            self.reloadTableViewClosure?(true)
            self.followingUsers = followingModel
        }
    }
}

//MARK:- API Call
extension UserDetailsViewModel {
    func fetchUser(completion : @escaping (( _ user:User?, _ error:String)->Void)) {
        if AppDelegate.isNetworkAvailable() {
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                let twitterClient = TWTRAPIClient(userID: userID)
                let urlString = "https://api.twitter.com/1.1/users/show.json?user_id="+userID
                twitterClient.sendTwitterRequest(twitterClient.urlRequest(withMethod: "GET", urlString:urlString , parameters: nil, error: nil), completion: { (response, data, error) in
                    if error == nil {
                        do {
                            if let user = try User.parseResponse(data: data ?? Data()) {
                                completion(user, "")
                                return
                            }
                        } catch _ { }
                    }
                    completion(nil, "Record not available!")
                })
            }
        }else {
            completion(nil, "Please check you Internet connection")
        }
    }
    
    func fetchEmail(completion : @escaping (( _ email:String?, _ error:String)->Void)) {
        if AppDelegate.isNetworkAvailable() {
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                let twitterClient = TWTRAPIClient(userID: userID)
                twitterClient.requestEmail { (strEmail, error) in
                    if error == nil {
                        completion(strEmail, "")
                        return
                    }
                    completion(nil, error?.localizedDescription ?? "")
                }
            }
        }else {
            completion(nil, "Please check you Internet connection")
        }
    }
    
    func fetchFollowers() {
        if AppDelegate.isNetworkAvailable() {
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                let twitterClient = TWTRAPIClient(userID: userID)
                twitterClient.sendTwitterRequest(twitterClient.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/followers/list.json", parameters: nil, error: nil), completion: { (response, data, error) in
                    if error == nil {
                        do {
                            if let followers = try Followers.parseResponse(data: data ?? Data()), let model = followers.users {
                                self.followerModel = model
                                self.users = self.followerModel
                                self.reloadTableViewClosure?(true)
                            }
                        } catch let err {
                            self.errorMeesage = err.localizedDescription
                        }
                    } else {
                        self.errorMeesage = error?.localizedDescription
                    }
                })
            }
        }else {
            self.errorMeesage = "Please check you Internet connection"
        }
    }
    
    func fetchFollowing() {
        if AppDelegate.isNetworkAvailable() {
            let store = TWTRTwitter.sharedInstance().sessionStore
            if let userID = store.session()?.userID {
                let twitterClient = TWTRAPIClient(userID: userID)
                twitterClient.sendTwitterRequest(twitterClient.urlRequest(withMethod: "GET", urlString: "https://api.twitter.com/1.1/friends/list.json", parameters: nil, error: nil), completion: { (response, data, error) in
                    if error == nil {
                        do {
                            if let followers = try Followings.parseResponse(data: data ?? Data()), let model = followers.users {
                                self.followingModel = model
                                self.users = self.followingModel
                                self.reloadTableViewClosure?(true)
                            }
                        } catch let err {
                            self.errorMeesage = err.localizedDescription
                        }
                    } else {
                        self.errorMeesage = error?.localizedDescription
                    }
                })
            }
        }
    }
    
    func logout(completion : @escaping (( _ isLogout:Bool)->Void)) {
        let storedSession = TWTRTwitter.sharedInstance().sessionStore
        if let userID = storedSession.session()?.userID {
            storedSession.logOutUserID(userID)
            completion(true)
        }
    }
}

