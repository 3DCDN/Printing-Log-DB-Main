//
//  SpotDetailViewController.swift
//  Printing-Log-DB
//
//  Created by XCodeClub on 2021-06-13.
//

import UIKit
import GooglePlaces
import MapKit

class SpotDetailViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var ratingDetailLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var spot: Spot!
    var regionDistance: CLLocationDegrees = 750.0
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
        if spot == nil {
            spot = Spot()
        }
        setupMapView()
        updateUserInterface()
    }
    func setupMapView() {
        let region = MKCoordinateRegion(center: spot.coordinate, latitudinalMeters: regionDistance, longitudinalMeters: regionDistance)
        mapView.setRegion(region, animated: true)
    }
    func updateUserInterface() {
        nameTextField.text = spot.name
        addressTextField.text = spot.address
        updateMap()
    }
    func updateMap() {
        mapView.removeAnnotations(mapView.annotations)
        mapView.addAnnotation(spot)
        mapView.setCenter(spot.coordinate, animated: true)
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
    @IBAction func lookupButtonPressed(_ sender: UIBarButtonItem) {
        let autocompleteController = GMSAutocompleteViewController()
            autocompleteController.delegate = self
        // Display the autocomplete view controller.
            present(autocompleteController, animated: true, completion: nil)
    }
}
extension SpotDetailViewController: GMSAutocompleteViewControllerDelegate {

  // Handle the user's selection.
  func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
    spot.name = place.name ?? "Unknown Place"
    spot.address = place.formattedAddress ?? "Unknown Address"
    spot.coordinate = place.coordinate
    updateUserInterface()
    dismiss(animated: true, completion: nil)
  }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

}

extension SpotDetailViewController: CLLocationManagerDelegate {
    func getLocation() {
        // Creating a location manager will automatically check authorization
        locationManager = CLLocationManager()
        locationManager.delegate = self
    }
    func handleAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.oneButtonAlert(title: "Location Service Denied!", message: "It may be that parental controls are restricting location use on this app")
        case .denied:
            showAlertToPrivacySettings(title: "User has not authorized location settings",message: "Select 'Settings' below to enable device settings and enable location services for this app")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        @unknown default:
            print("DEVELOPER ALERT: Uknown case of status in handleAuthorizationsStatus \(status)")
        }
    }
    func showAlertToPrivacySettings(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        guard let settingURL = URL(string: UIApplication.openSettingsURLString) else {
            print("Something went wrong while trying to open the UIApplication.openSettingsURLString")
            return
        }
        
    }
    func locationManager(manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus) {
        print("Checking Authorization Status...")
        handleAuthorizationStatus(status: status)
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard spot.name == "" else {
            return // return if we have a spot name, otherwise we'd overwrite the spot information with the current location
        }
        let currentLocation = locations.last ?? CLLocation()
        print("Current location is: \(currentLocation.coordinate.latitude), \(currentLocation.coordinate.longitude)")
        spot.coordinate = currentLocation.coordinate
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) in
            var locationName = ""
            if placemarks != nil {
                // get the first placemark
                let placemark = placemarks?.last
                // assign placemark to location name
                locationName = placemark?.name ?? "Uknown Parts"
            } else {
                print("Error retrieving place")
                locationName = "Could not find location"
            }
            self.mapView.userLocation.title = locationName
            self.spot.name = locationName
            self.updateUserInterface()
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("ERROR: \(error.localizedDescription) -Failed to get device location")
        
    }
    
} // last line of extension
