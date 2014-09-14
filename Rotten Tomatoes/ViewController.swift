//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/10/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var movieTableView: UITableView!
    
    @IBOutlet weak var movieBarItem: UITabBarItem!
    @IBOutlet weak var dvdBarItem: UITabBarItem!
    
    @IBOutlet weak var tabBar: UITabBar!
    var movies: [NSDictionary] = []
    var refreshControl = UIRefreshControl()
    
    var listingType: ListingType = ListingType.BoxOffice
    
    let apiKey = "h5m457aefmgkhdrm3ckgnrrk"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        alertView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 320, height: 50)
//        alertView.backgroundColor = UIColor.blackColor()
//        alertView.alpha = 0.8
        
//        alertView.hidden = true
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        tabBar.delegate = self
        
        // Default to Movie listings
        if tabBar.selectedItem == nil {
            tabBar.selectedItem = movieBarItem
        }
        navigationItem.title = tabBar.selectedItem?.title
        
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh movie listings", attributes: [NSForegroundColorAttributeName : UIColor.whiteColor()])
        refreshControl.addTarget(self, action: Selector("refreshData"), forControlEvents: UIControlEvents.ValueChanged)
        movieTableView.addSubview(refreshControl)
        
        fetchMovieData()
    }
    
    func fetchMovieData(refresh: Bool = false) {
        if !refresh {
            ZAActivityBar.showWithStatus("Fetching Movies...")
        }
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(getURLString()))
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            
            if error != nil {
//                self.alertView.hidden = false
                ZAActivityBar.showErrorWithStatus("Problem with connecting to network! Try again later.")
                println("Problem with connecting to network!")
            } else {
//                self.alertView.hidden = true
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                
                self.movies = dictionary["movies"] as [NSDictionary]
                
                self.movieTableView.reloadData()
                if !refresh {
                    ZAActivityBar.dismiss()
                }
            }
            
            if refresh {
                self.refreshControl.endRefreshing()
            } 
        })
    }
    
    func refreshData() {
        fetchMovieData(refresh: true)
    }
    
    func getURLString() -> String {
        let listingString = self.listingType.urlString()

        return "http://api.rottentomatoes.com/api/public/v1.0/lists/\(listingString).json?apikey=\(apiKey)&limit=50&country=us"
    }

    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        navigationItem.title = item.title
        if item.title == "Box Office" {
            listingType = ListingType.BoxOffice
        } else {
            listingType = ListingType.TopRentals
        }
        
        fetchMovieData()
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

        cell.posterView.alpha = 0.0
        cell.posterView.setImageWithURL(NSURL(string: posterUrl))
        UIView.animateWithDuration(0.5, animations: {
            cell.posterView.alpha = 1.0
        })

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

