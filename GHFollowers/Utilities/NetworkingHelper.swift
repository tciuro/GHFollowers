//
//  NetworkingHelper.swift
//  GHFollowers
//
//  Created by Tito Ciuro on 1/29/20.
//  Copyright © 2020 Tito Ciuro. All rights reserved.
//

import UIKit

struct NetworkingHelper {
    
    static func urls(from indexPaths: [IndexPath], list: [GHNetworkModeling], networkManager: GHNetworkCapable) -> [URL] {
        let relevantRows = Set<Int>(indexPaths.map { $0.item })
        var relevantFavorites = [GHNetworkModeling]()
        
        for (index, model) in list.enumerated() {
            if relevantRows.contains(index) {
                relevantFavorites.append(model)
            }
        }
        
        return relevantFavorites.map { $0.avatarUrl }
    }
    
}
