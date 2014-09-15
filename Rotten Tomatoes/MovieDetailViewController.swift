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
    @IBOutlet weak var synopsisScrollView: UIScrollView!
    
    var thumbImg: UIImage = UIImage()
    var movieDetails: MovieModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let movie = movieDetails {
            navigationItem.title = movie.title
            
            let thumbView = self.posterView.image
            posterView.setImageWithURL(NSURL(string: movie.posterUrl), placeholderImage: thumbImg)

            synopsisLabel.text = movie.synopsis
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
