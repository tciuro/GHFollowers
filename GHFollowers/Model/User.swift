//
//  User.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/8/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct User: Codable {
    var login: String
    var avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    var publicRepos: Int
    var publicGists: Int
    var hmtlUrl: String
    var following: Int
    var followers: Int
    var createdAt: String
}
