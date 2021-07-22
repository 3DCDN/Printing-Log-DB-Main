//
//  SpotPhotoCollectionViewCell.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-21.
//

import UIKit

class SpotPhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    var photo: Photo! {
        didSet {
            photoImageView.image = photo.image
        }
    }
}
