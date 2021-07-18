//
//  SpotReviewTableViewCell.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-07.
//

import UIKit

class SpotReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    
    @IBOutlet var starImageCollection: [UIImageView]!
    
    var review: Review! {
        didSet {
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
            
            for starImage in starImageCollection {
                // tags start at 0
                let imageName = starImage.tag < review.rating ? "star.fill" : "star"
                starImage.image = UIImage(systemName: imageName)
                starImage.tintColor = starImage.tag < review.rating ? .systemRed : .darkText
            }
        }  // end of didSet
    } // end of review structure
}
