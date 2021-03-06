//
//  enums.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/13/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

enum ListingType {
    case BoxOffice, TopRentals
    
    func urlString() -> String {
        switch self {
        case .BoxOffice:
            return "movies/box_office"
        case .TopRentals:
            return "dvds/top_rentals"
        }
    }
}