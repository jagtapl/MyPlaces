//
//  LocationCell.swift
//  MyPlaces
//
//  Created by LALIT JAGTAP on 4/29/18.
//  Copyright © 2018 LALIT JAGTAP. All rights reserved.
//

import UIKit


class LocationCell: UITableViewCell {
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    
    var locationToEdit: Location?
    var descriptionText = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(for location: Location) {
        if location.locationDescription.isEmpty {
            descriptionLabel.text = "(No desciption)"
        } else {
            descriptionLabel.text = location.locationDescription
            
            if let placemark = location.placemark {
                var text = ""
            if let s = placemark.subThoroughfare {
                text += s + " "
            }
            if let s = placemark.thoroughfare {
                text += s + " "
            }
            if let s = placemark.locality {
                text += s + " "
            }
                addressLabel.text = text
            } else {
                addressLabel.text = ""
            }
        }
        photoImageView.image = thumbnail(for: location)
    }
    
    func thumbnail(for location: Location) -> UIImage {
        if location.hasPhoto, let image = location.photoImage {
            return image.resized(withBounds: CGSize(width: 52, height: 52))
        }
        return UIImage()
    }
}
