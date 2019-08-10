//
//  UserDetailsViewController.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import TwitterKit
import TwitterCore
import SDWebImage

class UserDetailsViewController: UIViewController {
    
    //MARK:- Objects
    let viewModel:UserDetailsViewModel = UserDetailsViewModel()
    private let tblRefreshControl = UIRefreshControl()

    var showIndicator:Bool = false {
        didSet {
            activityIndicator.isHidden = !showIndicator
            if showIndicator {
                activityIndicator.startAnimating()
            }else {
                activityIndicator.stopAnimating()
            }
        }
    }
    //MARK:- @IBOutlet Objects
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    @IBOutlet weak var lblFollowers: UILabel!
    @IBOutlet weak var imgViewProfile: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupProfileImageView()
        
        viewModel.showErrorAlertClosure = { (error) in
            if !(error?.isEmpty ?? true){ self.presentAlert(message: error ?? "")}
            self.showIndicator = false
            self.tblRefreshControl.endRefreshing()
        }
        
        viewModel.reloadTableViewClosure = { (isReload) in
            self.showIndicator = false
            self.tblRefreshControl.endRefreshing()
            self.tblView.reloadData()
        }
        self.fetchDetails()
        viewModel.selectedIndex = 0
    }

    // MARK: - @IBAction
    @IBAction func segmentValueChanged(_ sender: Any) {
        if let segment:UISegmentedControl = sender as? UISegmentedControl {            
            showIndicator = true
            viewModel.selectedIndex = segment.selectedSegmentIndex
        }
    }
    
    @IBAction func btnSignoutTapped(_ sender: UIButton) {
        viewModel.logout { (logout) in
            if logout {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    // MARK: - Private
    private func setupTableView(){
        tblView.rowHeight = UITableView.automaticDimension
        tblView.estimatedRowHeight = 64
        tblView.refreshControl = tblRefreshControl
        tblRefreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
    }
    
    private func setupProfileImageView(){
        imgViewProfile.layer.cornerRadius = self.imgViewProfile.frame.size.width/2
        imgViewProfile.layer.borderWidth = 4
        imgViewProfile.layer.borderColor = UIColor.darkGray.cgColor
        imgViewProfile.clipsToBounds = true
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.fetchDetails()
        viewModel.selectedIndex = viewModel.selectedIndex
    }
    
    private func fetchDetails(){
        viewModel.fetchUser { (user, error) in
            if error.isEmpty == true {
                self.lblUsername.text = "@"+(user?.screenName ?? "")
                self.lblName.text = user?.name ?? ""
                self.lblFollowers.text = String(format:"%d", (user?.followersCount ?? 0))
                self.lblFollowing.text = String(format:"%d", (user?.friendsCount ?? 0))
                self.imgViewProfile.sd_setImage(with: URL(string: user?.profileImageUrl ?? ""), placeholderImage: UIImage(named: "icn_user"), options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
                    if image != nil {
                        self.imgViewProfile.image = image
                    }
                }
            }else {
                self.showIndicator = true
                self.tblRefreshControl.endRefreshing()
                self.presentAlert(message: error)
            }
        }
        
        viewModel.fetchEmail { (email, error) in
            if error.isEmpty == true {
                self.lblEmail.text = email ?? ""
            }else {
                self.showIndicator = true
                self.tblRefreshControl.endRefreshing()
                self.presentAlert(message: error)
            }
        }
    }
}

extension UserDetailsViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableCellIdentifier.User.rawValue, for: indexPath) as? UserTableViewCell else {
            return UITableViewCell()
        }
        guard let twitterUser = self.viewModel.users[indexPath.row] as? User else { return UITableViewCell() }
        cell.lblName?.text = twitterUser.name
        cell.lblAddress?.text = twitterUser.location
        cell.imgProfile.sd_setImage(with: URL(string: twitterUser.profileImageUrl ?? ""), placeholderImage: UIImage(named: "icn_user"), options: SDWebImageOptions.refreshCached) { (image, err, cacheType, url) in
            if image != nil {
                cell.imgProfile.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
}
