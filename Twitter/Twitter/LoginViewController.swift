//
//  LoginViewController.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    //MARK:- Objects
    let viewModel:LoginViewModel = LoginViewModel()
    
    //MARK:- Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        initialConfiguration()
        setupLoginTwitterView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.isLoggedIn()
    }
    
    //MARK:- Private Methods
    private func initialConfiguration(){
        //handle action results
        viewModel.completion = { (loginResult) in
            switch loginResult {
            case .success(let isSuccess):
                if isSuccess {
                    self.navigationToUserDetails()
                }
            case .fail(let error):
                if error.isEmpty == false { self.presentAlert(message: error)}
            }
        }
    }
    
    private func setupLoginTwitterView() {
        let logInButton = viewModel.twitterLoginButtun()
        logInButton.center = view.center
        view.addSubview(logInButton)
    }
    
    private func navigationToUserDetails() {
        if let userDetailsNavigation = storyboard?.instantiateViewController(withIdentifier: String(describing: UserDetailsNavigationController.self)) {
            present(userDetailsNavigation, animated: false, completion: nil)
        }
    }

}


