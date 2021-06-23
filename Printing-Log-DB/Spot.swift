//
//  Spot.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-06-15.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import MapKit

class Spot: NSObject, MKAnnotation {
    
    var name: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var averageRating: Double
    var numberOfReviews: Int
    var postingUserID: String
    var documentID: String
    // documentID will be the name of the document therefore will not be saved
    var dictionary: [String: Any]{
        return ["name": name, "address": address, "latitude": latitude, "longitude": longitute, "averageRating": averageRating, "numberOfReviews": numberOfReviews, "postingUserID": postingUserID]
    }
    var latitude: CLLocationDegrees {
        return coordinate.latitude
    }
    var longitute: CLLocationDegrees {
        return coordinate.longitude
    }
    var title: String? {
        return name
    }
    var subtitle: String? {
        return address
    }
    
    init(name: String,address: String, coordinate: CLLocationCoordinate2D,averageRating: Double, numberOfReviews: Int, postingUserID: String, documentID: String) {
        self.name = name
        self.address = address
        self.coordinate = coordinate
        self.averageRating = averageRating
        self.numberOfReviews = numberOfReviews
        self.postingUserID = postingUserID
        self.documentID = documentID
    }
    // used to update at multiple places at the same time when initializing Spot with default values or to change number of properties
    override convenience init() {
        self.init(name: "", address: "",coordinate: CLLocationCoordinate2D(), averageRating: 0.0, numberOfReviews: 0, postingUserID: "", documentID: "")
    }
    convenience init(dictionary: [String: Any]){
        let name = dictionary["name"] as! String? ?? ""
        let address = dictionary["address"] as! String? ?? ""
        let latitude = dictionary["latitude"] as! Double? ?? 0.0
        let longitude = dictionary["longitude"] as! Double? ?? 0.0
        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let averageRating = dictionary["averageRating"] as! Double? ?? 0.0
        let numberOfReviews = dictionary["numberOfReviews"] as! Int? ?? 0
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        
        self.init(name: name, address: address, coordinate: coordinate, averageRating: averageRating, numberOfReviews: numberOfReviews, postingUserID: postingUserID,documentID: "")
    }
    
    func saveData(completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = Auth.auth().currentUser?.uid else {
            print("ERROR: Could not save data because we don't have a valid posting User ID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing the data we want to save
        let dataToSave: [String: Any] = self.dictionary
        // if we have a Saved record, we'll have a documentID, otherwise .addDocument will create one
        if self.documentID == "" { // document is new so we need to create document via .addDocument
            var ref: DocumentReference? = nil
            ref = db.collection("spots").addDocument(data: dataToSave) { (error) in
                guard error == nil
                else {
                    print("ERROR: Could not add document \(String(describing: error?.localizedDescription))")
                    return completion(false)
                }
                self.documentID = ref!.documentID
                print("Added document: \(self.documentID)")
                completion(true)
            }
        } else { // document ID already exists and can save with .setData
            let ref = db.collection("spots").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                guard error == nil
                else {
                    print("ERROR: Could not save document \(String(describing: error?.localizedDescription))")
                    return completion(false)
                }
                print("Saved document: \(self.documentID)")
                completion(true)
            }
        }
    }
}
