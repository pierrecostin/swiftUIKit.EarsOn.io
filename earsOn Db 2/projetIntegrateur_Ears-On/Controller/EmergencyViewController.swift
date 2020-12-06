//
//  EmergencyViewController.swift
//  projetIntegrateur_Ears-On
//
//  Created by user172954 on 11/15/20.
//

import Foundation
import UIKit
import MapKit
import CoreLocation
import MessageUI

class EmergencyViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var switchMap: UISwitch!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var msgText: UITextView!
    
    @IBOutlet weak var text911Button: UIButton!
    
    let locationManager = CLLocationManager()
    let regionInMeters: Double = 10000
    
    override func viewDidLoad() {
          super.viewDidLoad()
          checkLocationServices()
          dismissKeyboard()
        
        msgText.layer.borderColor=UIColor.black.cgColor
        msgText.layer.borderWidth=2.0
        msgText.layer.cornerRadius=10.0
        text911Button.layer.cornerRadius=15.0
    }
    
    //MARK: - MAP
    func setupLocationManager () {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    @IBAction func mapHidden(_ sender: UISwitch) {
        if switchMap.isOn == true{
            mapView.isHidden = false
        }else{
            mapView.isHidden = true
        }
    }
  
    
    func centerViewOnUserLocation() {
           if let locate = locationManager.location?.coordinate {
               let region = MKCoordinateRegion.init(center: locate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
               mapView.setRegion(region, animated: true)
           }
       }
    
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }else{
            // montrer une alerte pour laisser savoir l'utilisateur qu'il doit activer ses parametres de localisation
        }
    }
    func checkLocationAuthorization() {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedWhenInUse:
              mapView.showsUserLocation = true
              centerViewOnUserLocation()
              locationManager.startUpdatingLocation()
              break
          case .denied:
              // Show alert instructing them how to turn on permissions
              break
          case .notDetermined:
              locationManager.requestWhenInUseAuthorization()
          case .restricted:
              // Show an alert letting them know what's up
              break
          case .authorizedAlways:
              break
          @unknown default:
            fatalError()
          }
      }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        msgText.resignFirstResponder()
        return true
    }
    
    @objc func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
    view.addGestureRecognizer(tap)
        view.endEditing(true)
    }
    
    private func presentAlert(with error: String) {
        let alert = UIAlertController(title: "Notification", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - SMS
    @IBAction func onSMSPress(_ sender:
    UIButton) {
        if MFMessageComposeViewController.canSendText() {
               
               let controller = MFMessageComposeViewController()
               controller.body = self.msgText.text
               controller.recipients = [self.phoneNumber.text!]
               controller.messageComposeDelegate = self
               self.present(controller, animated: true, completion: nil)
            presentAlert(with: "Le message a été envoyer")
               }
           else {
                print("Cannot send text")
            presentAlert(with: "Vous devez prendre contact avec votre operateur pour activer cette option")
           }
        }
    }
//MARK: - Extensions : MAP / SMS

extension EmergencyViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
         guard let locate = locations.last else { return }
        
         let region = MKCoordinateRegion.init(center: locate.coordinate, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
         mapView.setRegion(region, animated: true)
        
       
        
        let coord = locate.coordinate
        let longitude = coord.longitude //Latitude & Longitude as String
        let latitude = coord.latitude
        msgText.text = "j'ai besoin d'aide je suis ici : <\(latitude) , \(longitude)>  "
        }
     
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         checkLocationAuthorization()
     }
 }

extension EmergencyViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}



