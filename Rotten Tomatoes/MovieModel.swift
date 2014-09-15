//
//  MovieModel.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/14/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

class MovieModel {
    var title, mpaa, synopsis: NSString
    var runtime, criticScore, audienceScore: Int
    
    init(dictionary: NSDictionary){
        title = dictionary["title"] as NSString
        mpaa = dictionary["mpaa_rating"] as NSString
        synopsis = dictionary["synopsis"] as NSString
        runtime = dictionary["runtime"] as Int
        
        let ratings = dictionary["ratings"] as NSDictionary
        criticScore = ratings["critics_rating"] as Int
        audienceScore = ratings["audience_score"] as Int
    }
    
}