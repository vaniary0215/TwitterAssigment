//
//  Users.swift
//  Twitter
//
//  Created by Apple Inc. on 10/08/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import Foundation

struct Followings: Codable {
    var previousCursor: Int?
    var totalCount: Int?
    var nextCursorStr: String?
    var previousCursorStr: String?
    var users: [User]? = []
    var nextCursor: Int?
    
    public static func parseResponse(data: Data) throws -> Followings? {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return try decoder.decode(Followings.self, from: data)
    }
}
