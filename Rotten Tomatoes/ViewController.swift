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
    var refreshControl = UIRefreshControl()
    
    let apiKey = "h5m457aefmgkhdrm3ckgnrrk"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.dataSource = self

        refreshControl.attributedTitle = NSAttributedString(string: "Refresh movie listings")
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.addSubview(refreshControl)
        
        fetchMovieData()
    }
    
    func fetchMovieData(refresh: Bool = false) {
        ZAActivityBar.showWithStatus("Fetching Movies...")
        
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(getURLString()))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            
            self.movies = dictionary["movies"] as [NSDictionary]
            
            self.movieTableView.reloadData()
            ZAActivityBar.dismiss()
            
            if refresh {
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    func refreshData() {
        fetchMovieData(refresh: true)
    }
    
    func getURLString() -> String {
        return "http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=\(apiKey)&limit=20&country=us"
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
        
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["thumbnail"] as String

        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "detailSegue") {
            var detailViewController = segue.destinationViewController as MovieDetailViewController
            
            let indexPath = movieTableView.indexPathForSelectedRow()!
            detailViewController.movieDetails = movies[indexPath.row]
            
            let movieCell = movieTableView.cellForRowAtIndexPath(indexPath) as MovieTableViewCell
            detailViewController.thumbImg = movieCell.posterView.image!
        }
    }
}

