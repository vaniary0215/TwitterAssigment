//
//  User.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit

struct User: Codable {
    var name: String?
    var screenName: String?
    var profileImageUrl: String?
    var profileImageUrlHttps: String?
    var location: String?
    var followersCount:Int?
    var friendsCount:Int?
    var id:Int?
    var idStr: String?
    var description: String?
    var url: String?
    
    public static func parseResponse(data: Data) throws -> User? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(User.self, from: data)
    }
    
    
}
