//
//  NetworkingHelper.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/29/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

struct NetworkingHelper {
    
    static func avatarURLs(for list:[GHNetworkModeling], indexPaths: [IndexPath]) -> [URL] {
        var followerURLs = [URL]()
        
        for indexPath in indexPaths {
            let model = list[indexPath.item]
            followerURLs.append(model.avatarUrl)
        }
        
        return followerURLs
    }
    
}
