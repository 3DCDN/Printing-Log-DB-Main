//
//  SpotReviewTableViewCell.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-07.
//

import UIKit

class SpotReviewTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewTitleLabel: UILabel!
    @IBOutlet weak var reviewTextLabel: UILabel!
    var review: Review! {
        didSet {
            reviewTitleLabel.text = review.title
            reviewTextLabel.text = review.text
        }
    }
}
