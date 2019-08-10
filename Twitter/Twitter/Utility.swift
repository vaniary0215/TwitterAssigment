//
//  Utility.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

enum TwitterAssets:String {
    case consumerKey = "Sh4JYw4aQ773emLJTL9zlFFF2"
    case consumerSecret = "KYZk6x2O0HO8e1ClUyqDDMjXOnYJhjwHBXrY4PJ6M7OFBxkE7z"
}

enum LoginResult {
    case success(isSuccess:Bool)
    case fail(error:String)
}

enum TableCellIdentifier:String {
    case User = "UserTableViewCell"
}
