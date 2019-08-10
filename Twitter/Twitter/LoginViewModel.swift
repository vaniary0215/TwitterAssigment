//
//  LoginViewModel.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewModel: NSObject {
    var completion: ((_ result:LoginResult)-> ())?
    
    public func twitterLoginButtun() -> UIButton {
        return TWTRLogInButton(logInCompletion: { session, error in
            if (session != nil) {
                self.completion?(LoginResult.success(isSuccess: true))
                return
            }
            self.completion?(LoginResult.fail(error: String(describing: error?.localizedDescription)))
        })
    }
    
    public func isLoggedIn(){
        let storedSession = TWTRTwitter.sharedInstance().sessionStore
        if let userID = storedSession.session()?.userID {
            if (userID.isEmpty == false) {
                self.completion?(LoginResult.success(isSuccess: true))
                return
            }
        }
        self.completion?(LoginResult.success(isSuccess: false))
    }
}
