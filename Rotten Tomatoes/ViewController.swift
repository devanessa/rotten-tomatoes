//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/10/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    var movies: [NSDictionary] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self
        let apiKey = "h5m457aefmgkhdrm3ckgnrrk"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(apiKey)&limit=20&country=us"
        
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(RottenTomatoesURLString))
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            
            self.movies = dictionary["movies"] as [NSDictionary]
            
            self.movieTableView.reloadData()
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("moviecell") as MovieTableViewCell
        
        // turn this into a Movie object??
        var movie = movies[indexPath.row]
        
        cell.titleLabel.text = movie["title"] as? String
        cell.synopsisLabel.text = movie["synopsis"] as? String
        
        var posters = movie["posters"] as NSDictionary
        var posterUrl = posters["thumbnail"] as String

        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let movieCell = movieTableView.cellForRowAtIndexPath(indexPath) as MovieTableViewCell
        
        let detailedViewController = MovieDetailsViewController()
        detailedViewController.posterView = UIImageView(image: movieCell.posterView.image)
        
        self.navigationController?.pushViewController(detailedViewController, animated: true)
    }
}

