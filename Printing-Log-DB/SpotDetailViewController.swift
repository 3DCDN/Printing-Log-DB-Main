//
//  SpotDetailViewController.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-06-13.
//

import UIKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ratingDetailLabel: UILabel!
    
    var spot: Spot!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if spot == nil {
            spot = Spot()
        }
        updateUserInterface()
    }
    func updateUserInterface() {
        nameTextField.text = spot.name
        addressTextField.text = spot.address
    }
    func updateFromInterface() {
        spot.name = nameTextField.text!
        spot.address = addressTextField.text!
        
    }
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
            
        } else {
            navigationController?.popViewController(animated: true)
        }
        
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateFromInterface()
        spot.saveData { (success) in
            if success {
                self.leaveViewController()
            } else {
                // need to notify user through an Alert
                self.oneButtonAlert(title: "Save Failed", message: "For some reason, the data did not save to the cloud")
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
}
