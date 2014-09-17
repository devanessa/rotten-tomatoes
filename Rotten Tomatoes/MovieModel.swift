//
//  MovieModel.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/14/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import Foundation

class MovieModel {
    var title, mpaa, synopsis, thumbUrl, posterUrl, releaseDate: String
    var runtime, criticScore, audienceScore: NSInteger
    
    init(dictionary: NSDictionary){
        title = dictionary["title"] as String
        mpaa = dictionary["mpaa_rating"] as String
        synopsis = dictionary["synopsis"] as String
        
        // this sometimes crashes if runtime was set as ""
        var run: NSInteger? = dictionary["runtime"] as? NSInteger
        if run != nil {
            self.runtime = run!
        } else {
            self.runtime = 0
        }
//        runtime = 0     // FIXME... this crashes if runtime is ""
        let dates = dictionary["release_dates"] as NSDictionary
        releaseDate = dates["theater"] as String

        let ratings = dictionary["ratings"] as NSDictionary
        criticScore = ratings["critics_score"] as NSInteger
        audienceScore = ratings["audience_score"] as NSInteger
        
        let posters = dictionary["posters"] as NSDictionary
        thumbUrl = posters["thumbnail"] as String
        // Hack to replace 'tmb' with 'ori' since API only returns thumb URLs
        posterUrl = thumbUrl.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
    }
    
    class func moviesFromDictionaryList(movieDict: [NSDictionary]) -> [MovieModel] {
        var moviesList = [MovieModel]()
        for movieData in movieDict {
            moviesList.append(MovieModel(dictionary: movieData))
        }
        return moviesList
    }
}