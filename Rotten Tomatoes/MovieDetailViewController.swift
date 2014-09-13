//
//  MovieDetailViewController.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/13/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    var thumbImg: UIImage = UIImage()
    var movieDetails: NSDictionary = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movieDetails["title"] as? String
        synopsisLabel.text = movieDetails["synopsis"] as? String
        
        let posters = movieDetails["posters"] as NSDictionary
        var originalPosterURL = posters["original"] as String
        originalPosterURL = originalPosterURL.stringByReplacingOccurrencesOfString("tmb", withString: "ori")
        
        let thumbView = self.posterView.image
        posterView.setImageWithURL(NSURL(string: originalPosterURL), placeholderImage: thumbImg)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
