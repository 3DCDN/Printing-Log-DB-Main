//
//  Reviews.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-05.
//

import Foundation
import Firebase

class Reviews {
    var reviewArray: [Review] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").document(self.reviewArray.ID).collection(Reviews).addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listenener \(error!.localizedDescription)")
                return completed()
            }
            // clean out the existing array since new data will load
            self.reviewArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let review = Reviews(dictionary: document.data())
                review.documentID = document.documentID
                self.reviewArray.append(spot)
                
            }
            completed()
        }
    }
    
    
}
