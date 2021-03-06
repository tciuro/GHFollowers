//
//  Follower.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/8/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import Foundation

struct Follower: Codable, Equatable, Hashable, GHNetworkModeling {
    var login: String
    var avatarUrl: URL
}
