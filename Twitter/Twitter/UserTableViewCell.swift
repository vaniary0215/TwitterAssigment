//
//  UserTableViewCell.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImageView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    private func setupProfileImageView(){
        imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width/2
        imgProfile.layer.borderWidth = 2
        imgProfile.layer.borderColor = UIColor.lightGray.cgColor
        imgProfile.clipsToBounds = true
    }
}
