//
//  PhotoViewController.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-07-15.
//

import UIKit

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

    }
    func updateUserInterface() {
        
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
        //TODO: more setup needed here
        leaveViewController()
    }
    
}

