//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/10/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITabBarDelegate, UISearchBarDelegate, UISearchDisplayDelegate {

    @IBOutlet weak var movieTableView: UITableView!
    
    @IBOutlet weak var movieBarItem: UITabBarItem!
    @IBOutlet weak var dvdBarItem: UITabBarItem!
    
    @IBOutlet weak var tabBar: UITabBar!

    @IBOutlet weak var searchBar: UISearchBar!
    
    var movies: [MovieModel] = []
    var filteredMovies: [MovieModel] = []
    
    var refreshControl = UIRefreshControl()
    
    var listingType: ListingType = ListingType.BoxOffice
    
    let apiKey = "h5m457aefmgkhdrm3ckgnrrk"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let request = NSMutableURLRequest(URL: NSURL.URLWithString(getURLString()))
        request.cachePolicy = NSURLRequestCachePolicy.ReturnCacheDataElseLoad
        
        if !refresh {
            ZAActivityBar.showWithStatus("Fetching Movies...")
        } else {
            // Force reload when pulling down to refresh
            request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData
        }
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            
            if error != nil {
                ZAActivityBar.showErrorWithStatus("Problem with connecting to network! Try again later.")
                // How do I not cache here
            } else {
                var errorValue: NSError? = nil
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                
                let movieDict = dictionary["movies"] as [NSDictionary]
                self.movies = MovieModel.moviesFromDictionaryList(movieDict)
                
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
        if tableView == self.searchDisplayController!.searchResultsTableView {
            return filteredMovies.count
        } else {
            return movies.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("detailSegue", sender: tableView)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCellWithIdentifier("moviecell") as MovieTableViewCell
        
        var movie: MovieModel
        if tableView == self.searchDisplayController!.searchResultsTableView {
            movie = filteredMovies[indexPath.row]
        } else {
            movie = movies[indexPath.row]
        }
        
        cell.titleLabel.text = movie.title
        cell.synopsisLabel.text = movie.synopsis
        cell.setAudienceScoreLabel(movie.audienceScore)
        cell.setCriticScoreLabel(movie.criticScore)
        
        cell.posterView.alpha = 0.0
        cell.posterView.setImageWithURL(NSURL(string: movie.thumbUrl))
        UIView.animateWithDuration(0.5, animations: {
            cell.posterView.alpha = 1.0
        })

        return cell
    }
    
    func filterContentForSearchTerm(searchTerm: String) {
        filteredMovies = []

        filteredMovies = movies.filter({ (movie: MovieModel) -> Bool in
            let match = movie.title.rangeOfString(searchTerm)
            return match != nil
        })

    }
    
    func searchDisplayController(controller: UISearchDisplayController, willShowSearchResultsTableView tableView: UITableView) {
        tableView.rowHeight = movieTableView.rowHeight
    }
    
    func searchDisplayController(controller: UISearchDisplayController, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchTerm(searchString)
        return true
    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchTerm(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "detailSegue") {
            var detailViewController = segue.destinationViewController as MovieDetailViewController
            
            var indexPath: NSIndexPath
            if sender as UITableView == self.searchDisplayController!.searchResultsTableView {
                indexPath = self.searchDisplayController!.searchResultsTableView.indexPathForSelectedRow()!
                detailViewController.movie = filteredMovies[indexPath.row]
            } else {
                indexPath = movieTableView.indexPathForSelectedRow()!
                detailViewController.movie = movies[indexPath.row]
            }
            
            let movieCell = movieTableView.cellForRowAtIndexPath(indexPath) as MovieTableViewCell
            detailViewController.thumbImg = movieCell.posterView.image!
        }
    }
}

