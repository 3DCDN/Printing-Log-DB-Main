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
    var reviewUserID: String
    var reviewUserEmail: String
    var date: Date
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return ["title": title, "text": text, "rating": rating, "reviewUserID": reviewUserID, "reviewUserEmail": reviewUserEmail,"date": timeIntervalDate]
    }
    
    init(title: String, text: String, rating: Int, reviewUserID: String, reviewUserEmail: String, date: Date, documentID: String) {
        self.title = title
        self.text = text
        self.rating = rating
        self.reviewUserID = reviewUserID
        self.reviewUserEmail = reviewUserEmail
        self.date = Date()
        self.documentID = documentID

    }
    
    convenience init() {
        let reviewUserID = Auth.auth().currentUser?.uid ?? ""
        let reviewUserEmail = Auth.auth().currentUser?.email ?? "Unknown Email"
        self.init(title: "", text: "", rating: 0, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, date: Date(), documentID: "")
    }
    
    convenience init(dictionary: [String: Any]){
        //Note: dictionary is a collection of key-value pairs
        let title = dictionary["title"] as! String? ?? ""
        let text = dictionary["text"] as! String? ?? ""
        let rating = dictionary["rating"] as! Int? ?? 0
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let reviewUserID = dictionary["reviewUserID"] as! String? ?? ""
        let reviewUserEmail = dictionary["reviewUserEmail"] as! String? ?? ""
        let documentID = dictionary["documentID"] as! String? ?? ""
        //TODO: Need to setup date
        //let date = dictionary["dateFormatter"] as! String? ?? ""
      
        self.init(title: title, text: text, rating: rating, reviewUserID: reviewUserID, reviewUserEmail: reviewUserEmail, date: date, documentID: documentID)
    }
    
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Create the dictionary representing the data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we have a Saved record, we'll have a documentID, otherwise .addDocument will create one
        if self.documentID == "" { // document is new so we need to create document via .addDocument
            var ref: DocumentReference? = nil
            ref = db.collection("spots").document(spot.documentID).collection("reviews").addDocument(data: dataToSave) { (error) in
                guard error == nil
                else {
                    print("ERROR: Could not add document \(String(describing: error?.localizedDescription))")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID) to spot: \(spot.documentID)") //it worked!
                completion(true)
            }
        } else { // document ID already exists and can save with .setData
            let ref = db.collection("spots").document(spot.documentID).collection("reviews").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil
                else {
                    print("ERROR: Could not save document \(String(describing: error?.localizedDescription))")
                    return completion(false)
                }
                print("Saved document: \(self.documentID) in spot: \(spot.documentID)")
                completion(true)
            }
        }
    }
    
    func deleteData(spot: Spot,completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        db.collection("spots").document(spot.documentID).collection("reviews").document(documentID).delete { (error) in
            if let error = error {
                print("ERROR: Deleting document ID \(self.documentID) with error: \(error.localizedDescription)")
                completion(false)
            } else {
                print("Successfully deleted document \(self.documentID)")
                completion(true)
            }
        }
        
    }
    
}
