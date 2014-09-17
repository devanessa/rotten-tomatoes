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
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var mpaaLabel: UILabel!
    
    @IBOutlet weak var criticLabel: UILabel!
    @IBOutlet weak var audienceLabel: UILabel!
    
    @IBOutlet weak var criticImageView: UIImageView!
    
    @IBOutlet weak var contentView: UIView!
    
    var thumbImg: UIImage = UIImage()
    var movie: MovieModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        posterView.setImageWithURL(NSURL(string: movie.posterUrl), placeholderImage: thumbImg)
        
        navigationItem.title = movie.title
        titleLabel.text = movie.title
        
        dateLabel.text = "Released: \(movie.releaseDate)"
        
        if movie.runtime != 0 {
            durationLabel.text = "\(movie.runtime) minutes"
        } else {
            durationLabel.text = "" // leave runtime as blank
        }
        
        if movie.mpaa == "Unrated" { // don't need redundant 'Rated' string
            mpaaLabel.text = movie.mpaa
        } else {
            mpaaLabel.text = "Rated \(movie.mpaa)"
        }
        
        criticLabel.text = "\(movie.criticScore)%"
        audienceLabel.text = "\(movie.audienceScore)%"
        
        if movie.criticScore > 50 {
            criticImageView.image = UIImage(named: "Tomato")
        } else {
            criticImageView.image = UIImage(named: "Splat")
        }
        
        synopsisLabel.text = movie.synopsis
        synopsisLabel.sizeToFit()
        
        let contentHeight = synopsisLabel.frame.height + 160 // height of synopsis content and movie details
        let height = contentHeight + 475 // this is a truly magic number!
        scrollView.contentSize = CGSize(width: contentView.frame.width, height: height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
