//
//  Photo.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-16.
//

import UIKit
import Firebase

class Photo {
    
    var image: UIImage
    var description: String
    var photoUserID: String
    var photoUserEmail: String
    var date: Date
    var photoURL: String
    var documentID: String
    
    var dictionary: [String: Any] {
        let timeIntervalDate = date.timeIntervalSince1970
        return["description": description, "photoUserID": photoUserID, "photoUserEmail": photoUserEmail,"date": timeIntervalDate,"photoURL": photoURL]
    }
    // default initializer
    init(image: UIImage, description: String, photoUserID: String, photoUserEmail: String, date: Date, photoURL: String, documentID: String){
        self.image = image
        self.description = description
        self.photoUserID = photoUserID
        self.photoUserEmail = photoUserEmail
        self.date = date
        self.photoURL = photoURL
        self.documentID = documentID
    }
 // passes in empty strings or blank equivalents if array is empty
    convenience init() {
        let photoUserID = Auth.auth().currentUser?.uid ?? ""
        let photoUserEmail = Auth.auth().currentUser?.email ?? "Unknown Email"
        self.init(image: UIImage(), description: "", photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: Date(), photoURL: "", documentID: "")
    }
    // Creates new photo object from a dictionary
    convenience init(dictionary: [String: Any]){
        //Note: dictionary is a collection of key-value pairs
        let description = dictionary["description"] as! String? ?? ""
        let photoUserID = dictionary["photoUserID"] as! String? ?? ""
        let photoUserEmail = dictionary["photoUserEmail"] as! String? ?? ""
        let timeIntervalDate = dictionary["date"] as! TimeInterval? ?? TimeInterval()
        let date = Date(timeIntervalSince1970: timeIntervalDate)
        let photoURL = dictionary["photoURL"] as! String? ?? ""
 
      
        self.init(image: UIImage(), description: description, photoUserID: photoUserID, photoUserEmail: photoUserEmail, date: date, photoURL: photoURL, documentID: "")
    }
    func saveData(spot: Spot, completion: @escaping (Bool) -> ()) {
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        // convert photo.image to a data type that can be saved in Firebase Storage
        guard let photoData = self.image.jpegData(compressionQuality: 0.5)
        else {
            print("ERROR: Could not convert photo.image to jpeg")
            return
        }
        // create metadata in order to see data in Firebase Storage console
        let uploadMetaData = StorageMetadata()
        uploadMetaData.contentType = "image/jpeg"
        
        // create file if necessary
        if documentID == "" {
            documentID = UUID().uuidString
        }
        
        // create a storage reference to upload this image to the spot's folder
        let storageRef = storage.reference().child(spot.documentID).child(documentID)
        
        // create an upload task
        let uploadTask = storageRef.putData(photoData, metadata: uploadMetaData) { (metadata, error) in
            if let error = error {
                print("ERROR: Upload for \(uploadMetaData) failed See Error \(error.localizedDescription)")
            }
        }
        uploadTask.observe(.success) { (snapshot) in
            print("Upload to Firebase Storage was successful!")
            //TODO: Update with photoURL for smoother image loading
            // Create the dictionary representing the data we want to save
            let dataToSave: [String: Any] = self.dictionary
            let ref = db.collection("spots").document(spot.documentID).collection("photos").document(self.documentID)
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
        
        uploadTask.observe(.failure) { (snapshot) in
            if let error = snapshot.error {
                print("ERROR: Upload for task for file \(self.documentID) failed in spot \(spot.documentID) with error \(error.localizedDescription)")
            }
            completion(false)
        }
    }
    
}
