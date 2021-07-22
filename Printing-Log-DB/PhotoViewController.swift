//
//  PhotoViewController.swift
//  Printing-Log-DB
//
//  Created by Rich St.Onge on 2021-07-15.
//

import UIKit
import Firebase

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    // TODO: Change the dateFormatter to DD/MM/YYYY
    // TODO: Change the timeFormatter to HH:MM:SS
    dateFormatter.dateStyle = .medium
    dateFormatter.timeStyle = .none
    return dateFormatter
}()

class PhotoViewController: UIViewController {

    @IBOutlet weak var cancelBarButton: UIBarButtonItem!
    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var deleteBarButton: UIBarButtonItem!
    @IBOutlet weak var postedByLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    var spot: Spot! // need to keep track of spot accessed and associated with photo
    var photo: Photo!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide the keyboard if we tap outside of a field
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        guard spot != nil else {
            print("ERROR: No spot passed to ReviewTableViewController.swift")
            return
        }
        if photo == nil {
            photo = Photo()
        }
        updateUserInterface()

    }
    func updateUserInterface() {
        postedByLabel.text = "by: \(photo.photoUserEmail)"
        dateLabel.text = "on: \(dateFormatter.string(from: photo.date))"
        descriptionTextView.text = photo.description
        photoImageView.image = photo.image
        
        if photo.documentID == "" { // If true, this is a new photo
           addBordersToEditableObjects()
        } else {
            if photo.photoUserID == Auth.auth().currentUser?.uid { // Photo is posted by current user
                self.navigationItem.leftItemsSupplementBackButton = false
                saveBarButton.title = "Update"
                addBordersToEditableObjects()
                self.navigationController?.setToolbarHidden(false, animated: true)
            } else { // Photo is posted by different user
                saveBarButton.hide()
                cancelBarButton.hide()
                postedByLabel.text = "Posted by: \(photo.photoUserEmail)"
                descriptionTextView.isEditable = false
                descriptionTextView.backgroundColor = .white
            }
        }
    }
    
    func updateFromUserInterface() {
        photo.description = descriptionTextView.text!
        photo.image = photoImageView.image!
        
    }
    
    func addBordersToEditableObjects() {
        descriptionTextView.addBorder(width: 0.5, radius: 5.0, color: .black)
    }
    
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
            
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromUserInterface()
        photo.saveData(spot: spot) { (success) in
            if success {
                self.leaveViewController()
            } else {
                print("ERROR: Can't unwind from segue from Photo because of photo saving error...")
            }
        }
        
    }
    
}

