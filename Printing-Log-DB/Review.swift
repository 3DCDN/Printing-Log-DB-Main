//
//  Review.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-04.
//

import Foundation
import Firebase

class Review {
    
    var title: String
    var text: String
    var rating: Int
    var reviewerUserID: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["title": title, "text": text, "rating": rating, "reviewerUserID": reviewerUserID, "date": timeIntervalDate, "documentID": documentID]
    }
    
    init(title: String, text: String, rating: Int, reviewerUserID: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewerUserID = reviewerUserID
        self.date = Date()
        self.documentID = documentID

    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        //let reviewUserID = dictionary["reviewerUserID"] as! String? ?? ""
        self.init(title: "", text: "", rating: 0, reviewerUserID: reviewUserID, date: Date(), documentID: "")
    }
}
