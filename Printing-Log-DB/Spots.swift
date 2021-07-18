//
//  Spots.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-06-18.
//

import Foundation
import Firebase

class Spots {
    var spotArray: [Spot] = []
    var db: Firestore!
    
    init() {
        db = Firestore.firestore()
    }
    func loadData(completed: @escaping () -> ()){
        db.collection("spots").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("ERROR: adding the snapshot listenener \(error!.localizedDescription)")
                return completed()
            }
            // clean out the existing array since new data will load
            self.spotArray = []
            // there are querySnapshot!.documents.count documents in the snapshot
            for document in querySnapshot!.documents {
                // You'll have to make sure you have a dictionary initializer in the singular class
                let spot = Spot(dictionary: document.data())
                spot.documentID = document.documentID
                self.spotArray.append(spot)
                
            }
            completed()
        }
    }
    
}
