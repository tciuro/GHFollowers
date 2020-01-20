//
//  User.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/8/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct User: Codable {
    let login: String
    let avatarUrl: String
    var name: String?
    var location: String?
    var bio: String?
    let publicRepos: Int
    let publicGists: Int
    let hmtlUrl: String
    let following: Int
    let followers: Int
    let createdAt: String
}
