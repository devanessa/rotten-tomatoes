//
//  MovieModel.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/14/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

class MovieModel {
    var title: NSString
    var rating: NSString
    var synopsis: NSString
    
    init(dictionary: NSDictionary){
        title = dictionary["title"] as NSString
        rating = dictionary["rating"] as NSString
        synopsis = dictionary["synopsis"] as NSString
    }
    
}