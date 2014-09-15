//
//  MovieTableViewCell.swift
//  Rotten Tomatoes
//
//  Created by vli on 9/12/14.
//  Copyright (c) 2014 Vanessa. All rights reserved.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    @IBOutlet weak var criticScoreLabel: UILabel!
    @IBOutlet weak var audienceScoreLabel: UILabel!
    
    @IBOutlet weak var criticImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setCriticScoreLabel(score: NSInteger){
        if score > 50 {
            criticImage.image = UIImage(named: "Tomato")
        } else {
            criticImage.image = UIImage(named: "Splat")
        }
        setLabelScore(criticScoreLabel, score: score)
    }
    
    func setAudienceScoreLabel(score: NSInteger) {
        setLabelScore(audienceScoreLabel, score: score)
    }
    
    func setLabelScore(label: UILabel, score: NSInteger){
        label.text = "\(score)%"
    }
    
}
