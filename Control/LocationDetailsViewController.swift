//
//  DetailLocationViewController.swift
//  MyPlaces
//
//  Created by LALIT JAGTAP on 4/14/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit
import Foundation
import CoreLocation
import CoreData

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .short
    return formatter
}()

class LocationDetailsViewController: UITableViewController {
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var coordinate = CLLocationCoordinate2D(latitude:0, longitude:0)
    var placemark: CLPlacemark?
    var categoryName = "Bookstore"
    var managedObjectContext: NSManagedObjectContext!
    var date = Date()
    var descriptionText = ""

    var locationToEdit: Location? {
        didSet {
            if let location = locationToEdit {
                descriptionText = location.locationDescription
                categoryName = location.category
                date = location.date
                coordinate = CLLocationCoordinate2DMake(
                    location.latitude, location.longitude)
                placemark = location.placemark
            }
        }
    }
    
    // MARK :- target action
    @objc func hideKeyboard(_ gestureRecignizer: UIGestureRecognizer) {
        let point = gestureRecignizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        
        if indexPath != nil && indexPath!.section == 0 && indexPath!.row == 0 {
            return
        }
        descriptionTextView.resignFirstResponder()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let location = locationToEdit {
            title = "Edit Location"
        }
        
        
        descriptionTextView.text = descriptionText
        categoryLabel.text = categoryName
        
        latitudeLabel.text = String(format: "%0.8f", coordinate.latitude)
        longitudeLabel.text = String(format: "%0.8f", coordinate.longitude)
        
        if let placemark = placemark {
            addressLabel.text = string(from: placemark)
        } else {
            addressLabel.text = "No address found for this location"
        }
        
//        dateLabel.text = format(date: Date())
        dateLabel.text = format(date: date)

        // Hide keyboard
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        gestureRecognizer.cancelsTouchesInView = false
        tableView.addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PickCategory" {
            let controller = segue.destination as! CategoryPickerViewController
            controller.selectedCategoryName = categoryName
        }
    }
    
    @IBAction func categoryPickerDidPickCategory (_ segue: UIStoryboardSegue) {
        let controller = segue.source as! CategoryPickerViewController
        categoryName = controller.selectedCategoryName
        categoryLabel.text = categoryName
    }
    
    // MARK:- Private Methods
    func string(from placemark: CLPlacemark) -> String {
        var text = ""
        if let s = placemark.subThoroughfare {
            text += s + " "
        }
        if let s = placemark.thoroughfare {
            text += s
        }
        if let s = placemark.locality {
            text += s + " "
        }
        if let s = placemark.administrativeArea {
            text += s + " "
        }
        if let s = placemark.postalCode {
            text += s + ", "
        }
        if let s = placemark.country {
            text += s
        }
        return text
    }
    
    func format(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    //MARK:- Actions
    @IBAction func done(_ sender: Any) {
        let hudView = HudView.hud(inView: navigationController!.view, animated: true)

        //1
        let location: Location
        if let temp = locationToEdit {
            hudView.text = "Updated"
            location = temp
        } else {
            hudView.text = "Tagged"
            location = Location(context: managedObjectContext)
        }
        
        //2
        location.locationDescription = descriptionTextView.text
        location.category = categoryName
        location.latitude = coordinate.latitude
        location.longitude = coordinate.longitude
        location.date = date
        location.placemark = placemark
        //3
        do {
            try managedObjectContext.save()
            afterDelay(0.6) {
                hudView.hide()
                self.navigationController?.popViewController(animated: true)
            }
        } catch {
            //4
            fatalError("Error :\(error)")
        }
    

        
//        afterDelay(0.6, run: {
//            hudView.hide()
//            self.navigationController?.popViewController(animated: true)
//            })
        
//        let delayInSeconds = 0.6
//        DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds, execute: {
//            hudView.hide()
//            self.navigationController?.popViewController(animated: true)
//        })
    }
    
    @IBAction func cancel(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0 || indexPath.section == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            descriptionTextView.becomeFirstResponder()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 0 {
            return 88
        } else if indexPath.section == 2 && indexPath.row == 2 {
            addressLabel.frame.size = CGSize(width: view.bounds.size.width - 120, height: 10000)
            addressLabel.sizeToFit()
            addressLabel.frame.origin.x = view.bounds.size.width - addressLabel.frame.size.width - 16
            return addressLabel.frame.size.height + 20
        } else {
            return 44
        }
    }
}
